package org.ddd.application.service.event.impl;

import org.ddd.application.service.event.EventAppService;
import org.ddd.service.HiDomainService;
import org.springframework.stereotype.Service;

@Service
public class EventAppServiceImpl implements EventAppService {

    private final HiDomainService hiDomainService;
    public EventAppServiceImpl(HiDomainService hiDomainService) {
        this.hiDomainService = hiDomainService;
    }
    @Override
    public String sayHello(String name) {
        return hiDomainService.sayHi(name);
    }
}
