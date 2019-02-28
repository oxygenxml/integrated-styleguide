/**
 * Load the libraries for the Search page.
 */
define(["require", "config"], function() {
    require(['search'], function() {
        require([
            'menu',
            'searchAutocomplete',
            'webhelp',
            'template-module-loader'
        ]);
    });
});