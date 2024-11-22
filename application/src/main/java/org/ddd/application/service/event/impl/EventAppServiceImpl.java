package org.ddd.application.service.event.impl;

import org.ddd.application.service.event.EventAppService;
import org.springframework.stereotype.Service;

@Service
public class EventAppServiceImpl implements EventAppService {
    @Override
    public String sayHello(String name) {
        return "Hello " + name;
    }
}
