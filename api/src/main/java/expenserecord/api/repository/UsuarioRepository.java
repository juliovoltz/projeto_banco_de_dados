package expenserecord.api.repository;

import expenserecord.api.entidade.Usuario;
import org.springframework.data.jpa.repository.JpaRepository;


public interface UsuarioRepository extends JpaRepository<Usuario, String> {

}
