/// Utilities for generating URL-friendly heading anchor slugs.
///
/// Follows GitHub-flavored Markdown slug conventions:
/// lowercase, spaces → hyphens, strip non-alphanumeric, deduplicate with
/// `-1`, `-2` suffixes.
library;

/// Converts a heading text to a URL-friendly slug.
///
/// Example: `"Hello World!"` → `"hello-world"`.
String slugify(String text) {
  return text
      .toLowerCase()
      .trim()
      .replaceAll(RegExp(r'[^\w\s-]'), '') // strip non-alnum (keep hyphens)
      .replaceAll(RegExp(r'\s+'), '-') // spaces → hyphens
      .replaceAll(RegExp(r'-+'), '-'); // collapse multiple hyphens
}

/// Generates a unique anchor slug from [text], appending `-1`, `-2`, etc.
/// if [existing] already contains the base slug.
///
/// [existing] is the set of slugs already used in the document. This function
/// mutates [existing] by adding the returned slug.
String uniqueSlug(String text, Set<String> existing) {
  final base = slugify(text);
  var slug = base;
  var counter = 1;
  while (existing.contains(slug)) {
    slug = '$base-$counter';
    counter++;
  }
  existing.add(slug);
  return slug;
}
