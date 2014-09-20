### python logging
##### 普通日志

```sh
# -*- coding: utf-8 -*-

import logging
format = '%(asctime)s - %(filename)s:%(lineno)s - %(name)s - %(message)s'
logging.basicConfig(filename="test.log", format=FORMAT, level=logging.WARNING)

logging.info("info")
logging.error('error')
logging.debug('debug')
logging.warn('warning')
```

##### 设置handler日志
```sh
# -*- coding: utf-8 -*-

import logging
import logging.handlers

handler = logging.handlers.TimedRotatingFileHandler(SERVER_LOG_FILE, when="midnight")
format = '%(asctime)s - %(filename)s:%(lineno)s - %(name)s - %(message)s'
formatter = logging.Formatter(format)
handler.setFormatter(formatter)
logger = logging.getLogger()
logger.addHandler(handler)

logging.info("info")
logging.error('error')
logging.debug('debug')
logging.warn('warning')
```