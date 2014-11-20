# -*- coding: utf-8 -*-

import re
import time
from flask import request_started, request_finished, request, g

class RealIpMiddleware(object):

    def __init__(self, app):
        self.app = app

    def __call__(self, environ, start_response):
        host = environ.get('HTTP_X_REAL_IP', '')
        if host:
                environ['REMOTE_ADDR'] = host
        return self.app(environ, start_response)


class StatsdMiddleware(object):

    def __init__(self, flask_app, project_name, statsd_client):
        self.wsgi_app = flask_app.wsgi_app
        self.project_name = project_name
        self.statsd_client = statsd_client
        request_started.connect(self._log_request, flask_app)
        request_finished.connect(self._log_response, flask_app)

    def __call__(self, environ, start_response):
        return self.wsgi_app(environ, start_response)

    def _log_request(self, sender, **extra):
        if request.url_rule:
            g._request_start_time = time.time()

    def _log_response(self, sender, response, **extra):
        if not hasattr(g, '_request_start_time') or\
                response.mimetype not in ['application/json', 'text/html']:
            return

        url_rule = re.sub(r'<.*>/', '', request.url_rule.rule)
        url_key = (self.project_name + url_rule).strip('/').replace('/', '.')
        self.statsd_client.timing_since(url_key, g._request_start_time)
