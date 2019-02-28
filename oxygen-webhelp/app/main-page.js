/**
 * Load the Main Page (index.html) libraries.
 */
define(["require", "config"], function() {
    require([
        'menu',
        'searchAutocomplete',
        'webhelp',
        'search-init',
        'context-help',
        'template-module-loader',
        'bootstrap'
    ]);
});
