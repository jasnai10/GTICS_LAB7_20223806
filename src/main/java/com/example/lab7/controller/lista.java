package com.example.lab7.controller;

import com.example.lab7.entity.Trabajador;
import com.example.lab7.repository.TrabajadorRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.ArrayList;
import java.util.List;

@Controller
public class lista {

    @Autowired
    TrabajadorRepository trabajadorRepository;

    @GetMapping(value = "/lista")
    public String lista(Model model){
        List<Trabajador> trabajadores = trabajadorRepository.findAll();
        model.addAttribute("trabajadores",trabajadores);
        return "vista";
    }
}
