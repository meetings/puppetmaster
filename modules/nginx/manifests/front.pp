/* Class: front
 *
 * 2014-11-20 / Meetin.gs
 */
class nginx::front() inherits nginx {
    class {
        'nginx::ssl':;
    }

    nginx::enable {
        '000-beta-http-core-pool':;
        '000-live-http-core-pool':;
        '000-dcp-core-pool':;
        '000-pools':;
        'api-meetings-sites':;
        'beta-dicolenet-sites':;
        'beta-meetings-sites':;
        'blogging-sites':;
        'cuty-service':;
        'default-proxy':;
        'dev-dicolenet-sites':;
        'dev-meetings-sites':;
        'dicole.net':;
        'events-service':;
        'live-blog-sites':;
        'media.dicole.com':;
        'meetin.gs':;
        'platform-meetings-sites':;
        'puppetmaster.dicole.net':;
        'thelanguagepoint.com':;
        'track-meetings-sites':;
        'ubuntu.meetin.gs':;
        'urlcache.meetin.gs':;
        'web-sites':;
        'xxx-dicolenet-catchall':;
        'xxx-meetings-catchall':;
    }
}
