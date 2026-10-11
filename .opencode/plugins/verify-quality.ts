/**
 * AC/DC inner loop for OpenCode V2.
 *
 * V2 replaced V1's `session.idle` and `tool.execute.before` plugin hooks with
 * the public event stream and permission rules. This plugin handles idle
 * sessions (Verify + Solve); protected edits are requested by `edit`
 * permissions in opencode.json.
 */
import { Plugin } from "@opencode/plugin";

type EventLike = {
  type: string;
  properties?: { sessionID?: string; sessionId?: string; session?: { id?: string } };
};

export default Plugin.define({
  id: "acdc.verify",
  async setup(ctx) {
    const controller = new AbortController();
    const attempts = new Map<string, number>();

    void (async () => {
      for await (const event of ctx.event.subscribe({ signal: controller.signal })) {
        const idle = event as unknown as EventLike;
        if (idle.type !== "session.idle") continue;
        const sessionID = idle.properties?.sessionID ?? idle.properties?.sessionId ?? idle.properties?.session?.id;
        if (!sessionID) continue;

        const process = Bun.spawn(["bash", "-lc", "./scripts/acdc-verify.sh --fast"], {
          cwd: ctx.location.directory,
          stdout: "pipe",
          stderr: "pipe",
        });
        if ((await process.exited) === 0) {
          attempts.delete(sessionID);
          continue;
        }

        const attempt = (attempts.get(sessionID) ?? 0) + 1;
        attempts.set(sessionID, attempt);
        const report = (await new Response(process.stderr).text()) || (await new Response(process.stdout).text());
        const message =
          attempt >= 3
            ? `AC/DC falló tras 3 intentos; escala a un humano. Informe:\n${report}`
            : `AC/DC verify falló (intento ${attempt}/3). Corrige y vuelve a verificar:\n${report}`;
        await ctx.session.synthetic({ sessionID, text: message });
      }
    })().catch(console.error);

    return () => controller.abort();
  },
});
