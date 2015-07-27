# -*- coding: utf-8 -*-

import memcache
import functools


def mc_cached(mclient, prefix, timeout=600):
    assert isinstance(mclient, memcache.Client)

    def decorator(f):
        @functools.wraps(f)
        def run(*args, **kwargs):
            key = prefix + str(args[0])
            response = mclient.get(key)
            if response is None:
                response = f(*args, **kwargs)
                mclient.set(key, response, timeout)
            return response
        return run
    return decorator


def mc_multi_cached(mclient, prefix, timeout=600):
    assert isinstance(mclient, memcache.Client)

    def decorator(func):
        @functools.wraps(func)
        def run(*args, **kwargs):
            assert isinstance(args[0], list)
            data = mclient.get_multi(args[0], key_prefix=prefix)
            not_exist_ids = [key for key in args[0] if key not in data.keys()]
            if not_exist_ids:
                response = func(not_exist_ids)
                mclient.set_multi(response, time=timeout, key_prefix=prefix)
                data.update(response)
            return data
        return run
    return decorator
