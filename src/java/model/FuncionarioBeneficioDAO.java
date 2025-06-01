package model;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class FuncionarioBeneficioDAO extends DataBaseDAO {

    public FuncionarioBeneficioDAO() throws Exception {}

    public void removerTodosDeFuncionario(int idFuncionario) throws Exception {
        String sql = "DELETE FROM funcionario_beneficio WHERE funcionario_idFfuncionario=?";
        this.conectar();
        try (PreparedStatement pstm = conn.prepareStatement(sql)) {
            pstm.setInt(1, idFuncionario);
            pstm.executeUpdate();
        } finally {
            this.desconectar();
        }
    }

    public void adicionarBeneficioFuncionario(int idFuncionario, int idBeneficio, double valor) throws Exception {
        String sql = "INSERT INTO funcionario_beneficio (funcionario_idFfuncionario, beneficio_idBeneficio, valor) VALUES (?, ?, ?)";
        this.conectar();
        try (PreparedStatement pstm = conn.prepareStatement(sql)) {
            pstm.setInt(1, idFuncionario);
            pstm.setInt(2, idBeneficio);
            pstm.setDouble(3, valor);
            pstm.executeUpdate();
        } finally {
            this.desconectar();
        }
    }

    public List<Beneficio> listarBeneficiosDoFuncionario(int idFuncionario) throws Exception {
        List<Beneficio> lista = new ArrayList<>();
        String sql = "SELECT b.idBeneficio, b.nome, b.descricao, fb.valor " +
                     "FROM beneficio b INNER JOIN funcionario_beneficio fb " +
                     "ON b.idBeneficio = fb.beneficio_idBeneficio " +
                     "WHERE fb.funcionario_idFfuncionario=?";
        this.conectar();
        try (PreparedStatement pstm = conn.prepareStatement(sql)) {
            pstm.setInt(1, idFuncionario);
            try (ResultSet rs = pstm.executeQuery()) {
                while (rs.next()) {
                    Beneficio b = new Beneficio();
                    b.setIdBeneficio(rs.getInt("idBeneficio"));
                    b.setNome(rs.getString("nome"));
                    b.setDescricao(rs.getString("descricao"));
                    b.setValorTemporario(rs.getDouble("valor")); // valor do vínculo
                    b.setAtivoParaFuncionario(true); // para deixar checkbox marcado
                    lista.add(b);
                }
            }
        } finally {
            this.desconectar();
        }
        return lista;
    }
}
