package org.ddd.resource;

import org.ddd.application.service.event.EventAppService;
import org.ddd.application.service.event.impl.EventAppServiceImpl;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1")
public class HiController {

    private EventAppService eventAppService;
    public HiController(EventAppService eventAppService) {
        this.eventAppService = eventAppService;
    }
    @GetMapping("/hello")
    public String sayHi() {
        eventAppService = new EventAppServiceImpl();
        String win = "Win";
        return eventAppService.sayHello(win);
    }
}
