---
title: astro
---

## starlight mdx embed mapbox-gl margin tweak


As a component, both container and canvas will be added a class `.sl-markdown-content`.

```css 
.sl-markdown-content :not(a, strong, em, del, span, input, code) + :not(a, strong, em, del, span, input, code, :where(.not-content *)) {
 margin-top: 1rem;
}
```

There are two known problems:

1. Mapbox attribute will got an 1rem blank above.
2. The point location in map got an y offset, thus the click and hover event will be wired.

Add `not-content` to container works for me.

```html title="index.html"
<div id="map" class="not-content" ></div>
```