package expenserecord.api.repository;

import expenserecord.api.entidade.ViewSomaDespesasEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface ViewDespesasRepository extends JpaRepository<ViewSomaDespesasEntity, String> {

    @Query(value = "SELECT v FROM View_Soma_Despesas v WHERE v.cpfUsuario = ?1"
    )
    ViewSomaDespesasEntity findDespesas(String cpf);

}
