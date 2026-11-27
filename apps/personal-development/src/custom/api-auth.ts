// SYMPLRV3 SCAFFOLD — yours to edit. The generator NEVER overwrites this file.
// Attach auth to every generated API request here. By default this reads the
// access token from the generated session store (src/gen/features/session.ts):
// call setSession(access, refresh) after your login flow succeeds and every
// request is authenticated automatically. Replace freely for other schemes.

import { getAccessToken } from '../gen/features/session';

export async function getAuthHeaders(): Promise<Record<string, string>> {
  const token = getAccessToken();
  return token ? { Authorization: `Bearer ${token}` } : {};
}
