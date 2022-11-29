/* Module: postfix
 *
 * Enable sending email.
 *
 * 2014-02-17 / Meetin.gs
 */
class postfix() {
    stage {
        'first':;
        'third':;
    }

    Stage['first'] -> Stage['main'] -> Stage['third']

    class {
        'postfix::passwdfix':  stage => first;
        'postfix::postfix':    stage => main;
        'postfix::queuewatch': stage => third;
    }
}
