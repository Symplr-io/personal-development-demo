jest.setTimeout(30000);
import { Screen14AudioFullPlayerScreen } from '../../src/gen/screens/Screen14AudioFullPlayerScreen';
import { renderScreen } from '../support/smoke';

it('the chevron that dismisses the player says so', () => {
  // renderScreen returns the test renderer's JSON; the chevron is w:6:257 and its
  // press runs navigation.goBack()
  const json = JSON.stringify(renderScreen(Screen14AudioFullPlayerScreen));
  const node = json.match(/"testID":"w:6:257"[^}]*/)?.[0] ?? '';
  expect(node).toContain('"accessibilityLabel":"Close player"');
});
