# -*- coding: utf-8 -*-

from flask import Response, render_template

def make_response():
    response = Response(render_template("test.csv").decode("utf-8").encode("GBK"))
    response.headers['Content-Disposition'] = 'attachment; filename=test.csv'
    response.headers['Content-Type'] = 'text/csv; charset=UTF-8'
    return response
