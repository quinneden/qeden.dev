# Design Spec: Caret Alignment Fix

Fix the misaligned red caret (`^`) on the home page (`content/_index.md`) so that it stays anchored to the first 'e' in 'evangelist' across all screen sizes and text wrapping scenarios.

## Problem
Currently, the caret is a separate block element with a fixed `padding-left: 34ch`. On mobile devices or narrow windows where the text wraps, this fixed padding causes the caret to align with the wrong character or float in empty space.

## Proposed Solution
Use CSS relative/absolute positioning to anchor the caret to the specific character it points to.

### 1. Styles (`assets/css/custom.css`)
Add utility classes to handle the anchoring:

```css
.caret-wrapper {
  position: relative;
  display: inline-block;
}

.caret-symbol {
  position: absolute;
  top: 1.1em; /* Adjust based on line-height */
  left: 0;
  color: red;
  font-family: monospace;
  line-height: 1;
  pointer-events: none; /* Ensure it doesn't interfere with selection */
}
```

### 2. Content (`content/_index.md`)
Refactor the line to use the new classes:

```markdown
software dev, infra engineer, nix <span class="caret-wrapper">e<span class="caret-symbol">^</span></span>vangelist.
```

## Verification Plan
1.  **Desktop:** Verify the caret points to the 'e' in 'evangelist'.
2.  **Mobile:** Resize the browser window until the line wraps. Verify the caret stays with the 'e' on the new line.
3.  **Browser Compatibility:** Check rendering in Chrome/Safari/Firefox (simulated).
