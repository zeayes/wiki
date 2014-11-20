# -*- coding: utf-8 -*-

import os
from hashlib import sha256
from hmac import HMAC

def encrypt_password(password, salt=None):
    """
    encrypt password with random salt
    """
    if salt is None:
        salt = os.urandom(8)

    if isinstance(password, unicode):
        password = password.encode("utf-8")

    result = password
    for i in range(3):
        result = HMAC(result, salt, sha256).hexdigest()

    return salt + result

def validate_password(hashed, password):
    return hashed == encrypt_password(password, salt=hashed[:8])

if __name__ == '__main__':
    password = "123456"
    hashed = encrypt_password(password)
    print hashed, len(hashed)
    print validate_password(hashed, password)
