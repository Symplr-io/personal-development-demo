import React from 'react';
import renderer, { act } from 'react-test-renderer';
import { numCompare } from '../../src/gen/branch';
import { Checkbox } from '../../src/gen/components/form-widgets';

describe('numCompare', () => {
  it('compares two numbers by each op', () => {
    expect(numCompare(2, 'gt', 1)).toBe(true);
    expect(numCompare(1, 'gte', 1)).toBe(true);
    expect(numCompare(1, 'lt', 2)).toBe(true);
    expect(numCompare(2, 'lte', 2)).toBe(true);
    expect(numCompare(3, 'eq', 3)).toBe(true);
    expect(numCompare(3, 'eq', 4)).toBe(false);
  });
  it('is false while either side is not a number', () => {
    expect(numCompare(Number.NaN, 'gt', 1)).toBe(false);
    expect(numCompare(1, 'lt', Number.POSITIVE_INFINITY)).toBe(false);
  });
});

function text(el: React.ReactElement): string {
  let tree!: renderer.ReactTestRenderer;
  act(() => {
    tree = renderer.create(el);
  });
  const out = JSON.stringify(tree.toJSON());
  act(() => tree.unmount());
  return out;
}

describe('a checkbox label with a badge', () => {
  it('puts the title beside the badge and the rest of the label on the line below', () => {
    const out = text(
      <Checkbox testID="cb" value={false} onChange={() => {}} label={'Home\n12 Main Street'} badgeText="Default" />,
    );
    expect(out).toContain('"Home"');
    expect(out).toContain('"12 Main Street"');
    expect(out).toContain('"Default"');
  });
  it('keeps a one-line label whole beside the badge', () => {
    const out = text(<Checkbox testID="cb" value onChange={() => {}} label="Work" badgeText="New" />);
    expect(out).toContain('"Work"');
    expect(out).toContain('"New"');
  });
  it('starts the lower line with no empty first line when the label opens with a break', () => {
    const out = text(<Checkbox testID="cb" value={false} onChange={() => {}} label={'\nOnly below'} badgeText="Tag" />);
    expect(out).toContain('"Only below"');
  });
});
