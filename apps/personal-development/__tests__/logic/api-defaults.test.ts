const mockSent: Array<Record<string, unknown>> = [];
jest.mock('axios', () => {
  const instance = {
    request: async (config: Record<string, unknown>) => {
      mockSent.push(config);
      return { data: {}, status: 200 };
    },
    interceptors: { request: { use: () => 0 }, response: { use: () => 0 } },
  };
  const isAxiosError = (e: unknown) => Boolean(e && typeof e === 'object' && 'response' in (e as object));
  return { __esModule: true, default: { create: () => instance, isAxiosError }, isAxiosError, AxiosError: Error };
});

import * as SupabaseAuth from '../../src/gen/api/SupabaseAuth';
import * as SupabaseData from '../../src/gen/api/SupabaseData';

// signInWithOAuth waits on the system browser before any request goes out
const BROWSER_FLOWS = ['signInWithOAuth'];

const opsOf = (mod: Record<string, unknown>) =>
  Object.keys(mod).filter(
    (k) => typeof mod[k] === 'function' && !k.startsWith('use') && !BROWSER_FLOWS.includes(k),
  );

it.each([
  ['SupabaseAuth', SupabaseAuth as unknown as Record<string, unknown>],
  ['SupabaseData', SupabaseData as unknown as Record<string, unknown>],
])('every %s operation builds a request when it is called with no values at all', async (_name, mod) => {
  mockSent.length = 0;
  const ops = opsOf(mod);
  for (const op of ops) {
    await (mod[op] as () => Promise<unknown>)().catch(() => undefined);
  }
  expect(mockSent).toHaveLength(ops.length);
  for (const sent of mockSent) expect(typeof sent.url).toBe('string');
});
