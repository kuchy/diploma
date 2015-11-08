module.exports = function(grunt) {

    grunt.initConfig({
        latex: {
            src: [ 'draft/main.tex' ]
        },
        watch: {
            draft: {
                files: ['draft/**/*.tex'],
                tasks: ['latex','shell:open'],
                options: {
                    spawn: false
                }
            },
            bibliography: {
                files: ['draft/bibliography.bib'],
                tasks: ['shell:biber'],
                options: {
                    spawn: false
                }
            },
            web: {
                files: ['web/**/*.html'],
                tasks: ['htmllint'],
                options: {
                    spawn: false
                }
            }
        },
        shell: {
            open: {
                command: 'open draft/main.pdf'
            },
            biber: {
                command: 'cd draft/; biber main;'
            }

        },
        htmllint: {
            all: ['web/**/*.html']
        }
    });

    grunt.loadNpmTasks('grunt-latex');
    grunt.loadNpmTasks('grunt-shell');
    grunt.loadNpmTasks('grunt-contrib-watch');
    grunt.loadNpmTasks('grunt-html');

    grunt.registerTask('default', ['watch']);
};
