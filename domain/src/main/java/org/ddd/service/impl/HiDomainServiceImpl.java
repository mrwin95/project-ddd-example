package org.ddd.service.impl;

import org.ddd.repository.HiDomainRepository;
import org.ddd.service.HiDomainService;
import org.springframework.stereotype.Service;

@Service
public class HiDomainServiceImpl implements HiDomainService {

    private final HiDomainRepository hiDomainRepository;

    public HiDomainServiceImpl(HiDomainRepository hiDomainRepository) {
        this.hiDomainRepository = hiDomainRepository;
    }

    @Override
    public String sayHi(String name) {
        return hiDomainRepository.sayHi(name);
    }
}
