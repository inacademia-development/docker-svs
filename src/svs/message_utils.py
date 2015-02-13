import cherrypy
from oic.oic.message import AuthorizationErrorResponse

from svs.user_interaction import EndUserErrorResponse
from svs.log_utils import log_transaction_fail, log_negative_transaction_complete
from svs.utils import now, get_new_error_uid, get_timestamp
from svs.i18n_tool import ugettext as _


__author__ = 'regu0004'


def abort_with_enduser_error(transaction_id, client_id, environ, logger, log_msg):
    """Construct and show error page for the user.
    """
    t, uid = _log_fail(logger, log_msg, transaction_id, client_id, environ)
    raise EndUserErrorResponse(t, uid, "error_general", _("error_general"))


def abort_with_client_error(transaction_id, session, environ, logger, log_msg, error="access_denied", error_description=""):
    """Log error and send error message.

    :param error: OpenID Connect error code
    :param error_description: error message string
    :return: raises cherrypy.HTTPRedirect to send the error to the RP.
    """
    _log_fail(logger, log_msg, transaction_id, session["client_id"], environ)
    client_error_message(session["redirect_uri"], error, error_description)


def _log_fail(logger, log_msg, transaction_id, client_id, environ):
    t = now()
    uid = get_new_error_uid()
    log_transaction_fail(logger, environ, transaction_id, client_id, log_msg, timestamp=t, uid=uid)
    return t, uid


def client_error_message(redirect_uri, error="access_denied", error_description=""):
    """Construct an error response and send in fragment part of redirect_uri.
    :param redirect_uri: redirect_uri of the client
    :param error: OpenID Connect error code
    :param error_description: human readable description of the error
    """
    error_resp = AuthorizationErrorResponse(error=error, error_description=error_description)
    location = error_resp.request(redirect_uri, True)
    raise cherrypy.HTTPRedirect(location)


def negative_transaction_response(transaction_id, session, environ, logger, message, idp_entity_id):
    """Complete a transaction with a negative response (incorrect affiliation or no user consent).
    """
    _elapsed_transaction_time = get_timestamp() - session["start_time"]
    log_negative_transaction_complete(logger, environ, transaction_id, session["client_id"], idp_entity_id,
                                      now(), _elapsed_transaction_time, message)
    client_error_message(session["redirect_uri"], message)