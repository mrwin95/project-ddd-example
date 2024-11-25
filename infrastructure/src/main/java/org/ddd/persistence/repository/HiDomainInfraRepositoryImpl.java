package org.ddd.persistence.repository;

import org.ddd.repository.HiDomainRepository;
import org.springframework.stereotype.Service;

@Service
public class HiDomainInfraRepositoryImpl implements HiDomainRepository {
    @Override
    public String sayHi(String name) {
        return "Hi Infrastructure " + name;
    }
}
