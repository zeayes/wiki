# -*- coding: utf-8 -*-

import os

os.environ['DJANGO_SETTINGS_MODULE'] = 'graphite.settings'

from django.core.handlers.wsgi import WSGIHandler


application = WSGIHandler()
