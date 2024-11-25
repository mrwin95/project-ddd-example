package org.ddd.resource;

import org.ddd.application.service.event.EventAppService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1")
public class HiController {

    private final EventAppService eventAppService;
    public HiController(EventAppService eventAppService) {
        this.eventAppService = eventAppService;
    }
    @GetMapping("/hello")
    public String sayHi() {
        String win = "Win";
        return eventAppService.sayHello(win);
    }

    @GetMapping("/hello1")
    public String sayHi1() {
        String win = "H1";
        return eventAppService.sayHello(win);
    }
}
