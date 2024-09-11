
import { defineConfig } from 'vite';
import laravel from 'laravel-vite-plugin';
import { globSync } from "glob";

export default defineConfig({
    server: {
        hmr: {
            host: 'localhost',
        }
    },
    plugins: [
        laravel({
            input: globSync("resources/{css,js,images}/**/*.*", {
                ignore: "resources/js/bootstrap.js",
            }),
            refresh: true,
        }),
    ],
    build: {
        outDir: 'public/build',
    },
});
