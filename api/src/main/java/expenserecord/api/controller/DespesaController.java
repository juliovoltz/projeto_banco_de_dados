package expenserecord.api.controller;

import expenserecord.api.entidade.ViewSomaDespesasEntity;
import expenserecord.api.repository.ViewDespesasRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/despesa")
public class DespesaController {

    @Autowired
    private ViewDespesasRepository repository;

    @GetMapping(path = "/{cpf}")
    public ViewSomaDespesasEntity getDespesas(@PathVariable String cpf) {
        return repository.findDespesas(cpf);
    }


}
