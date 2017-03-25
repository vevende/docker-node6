const assert = require('assert');
const { spawnSync } = require('child_process')


describe('tests', function() {
    it('Check modules from packages.json are installed', function(done) {
        let ret = spawnSync('npm', ['ls', '--json', '--depth', '0'])
        let data = JSON.parse(ret.stdout);
        let installed = Object.keys(data.dependencies);

        assert.equal(installed.length, 2)
        assert(installed.indexOf('mocha') > -1)
        assert(installed.indexOf('has-module') > -1)

        done()
    })

    it('Common tools are installed', function(done) {
        assert.equal(spawnSync('which', ['git']).status, 0, 'Git is missing')
        assert.equal(spawnSync('which', ['python']).status, 0, 'Python is missing')
        assert.equal(spawnSync('which', ['make']).status, 0, 'Make is missing')
        assert.equal(spawnSync('which', ['gosu']).status, 0, 'gosu is missing')

        done()
    })
    
    it('Check docker extra entrypoints have run', function(done) {
        assert.equal(spawnSync('test', ['-f', '/tmp/hello-js']).status, 0, 'JS entrypoints has not run')
        assert.equal(spawnSync('test', ['-f', '/tmp/hello-sh']).status, 0, 'Script entrypoints has not run')

        done()
    })

    it('Check permissions for /app', function(done) {
        assert.equal(spawnSync('test', ['-w', '/app']).status, 0, 'Wrong permissions for /app')
        done()
    })
})

