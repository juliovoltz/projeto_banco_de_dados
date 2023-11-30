package expenserecord.api.entidade;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

import java.math.BigDecimal;
@Table(name = "View_Soma_Despesas")
@Entity(name = "View_Soma_Despesas")
public class ViewSomaDespesasEntity {
    @Id
    private String idTipo;
    private String categoria;

    private String cpfUsuario;
    private BigDecimal somaDespesas;
}
