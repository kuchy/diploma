module.exports = function(grunt) {

    grunt.initConfig({
        latex: {
            src: [ 'main.tex' ],
            options: {
                // Task-specific options go here.
            },
            your_target: {
                // Target-specific file lists and/or options go here.
                outputDirectory: 'build/pdf'
            },
        },
        watch: {
            scripts: {
                files: ['**/*.tex'],
                tasks: ['latex','shell'],
                options: {
                    spawn: false,
                }
            }
        },
        shell: {
            options: {
                stderr: false
            },
            target: {
                command: 'open main.pdf'
            }
        }
    });

    grunt.loadNpmTasks('grunt-latex');
    grunt.loadNpmTasks('grunt-shell');
    grunt.loadNpmTasks('grunt-contrib-watch');


    // By default, lint and run all tests.
    grunt.registerTask('default', ['watch']);

};