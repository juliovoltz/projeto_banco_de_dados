package expenserecord.api.controller;

import expenserecord.api.dto.CreateUsuarioDTO;
import expenserecord.api.dto.UpdateUsuarioDTO;
import expenserecord.api.entidade.Usuario;
import expenserecord.api.repository.UsuarioRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/usuario")
public class UsuarioController {

    @Autowired
    private UsuarioRepository usuarioRepository;

    @PostMapping
    public Usuario createUsuario(@RequestBody CreateUsuarioDTO usuarioDTO) {
        Usuario usuario = new Usuario();

        usuario.setCpf(usuarioDTO.cpf());
        usuario.setNome(usuarioDTO.nome());
        usuario.setSobrenome(usuarioDTO.sobrenome());
        usuario.setEmail(usuarioDTO.email());
        usuario.setTelefone(usuarioDTO.telefone());

        return usuarioRepository.save(usuario);
    }

    @GetMapping(path = "/{cpf}")
    public Usuario getUsuario(@PathVariable String cpf) {
        return usuarioRepository.findById(cpf).orElse(null);
    }

    @PutMapping(path = "/{cpf}")
    public Usuario updateEmailUsuario(@PathVariable String cpf, @RequestBody UpdateUsuarioDTO usuarioDTO) {
        Usuario usuario = usuarioRepository.findById(cpf).orElse(null);

        usuario.setEmail(usuarioDTO.email());

        return usuarioRepository.save(usuario);
    }

    @DeleteMapping(path = "/{cpf}")
    public void updateEmailUsuario(@PathVariable String cpf) {
        usuarioRepository.deleteById(cpf);
    }
}
