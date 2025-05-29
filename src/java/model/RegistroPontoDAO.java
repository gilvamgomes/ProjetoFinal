package model;

import java.sql.*;
import java.util.*;

public class RegistroPontoDAO extends DataBaseDAO {

    public RegistroPontoDAO() throws Exception {}

    public boolean gravar(RegistroPonto r) {
        try {
            this.conectar();
            String sql;
            if (r.getIdRegistro_ponto() == 0) {
                sql = "INSERT INTO registro_ponto (data, horaEntrada, horaSaida, funcionario_idFfuncionario) VALUES (?, ?, ?, ?)";
            } else {
                sql = "UPDATE registro_ponto SET data=?, horaEntrada=?, horaSaida=?, funcionario_idFfuncionario=? WHERE idRegistro_ponto=?";
            }
            PreparedStatement pstm = this.conn.prepareStatement(sql);

            pstm.setDate(1, r.getData());
            pstm.setTime(2, r.getHoraEntrada());

            if (r.getHoraSaida() != null) {
                pstm.setTime(3, r.getHoraSaida());
            } else {
                pstm.setNull(3, java.sql.Types.TIME);
            }

            pstm.setInt(4, r.getFuncionario_idFfuncionario());

            if (r.getIdRegistro_ponto() != 0) {
                pstm.setInt(5, r.getIdRegistro_ponto());
            }

            pstm.execute();
            this.desconectar();
            return true;

        } catch (Exception e) {
            System.out.println("Erro ao gravar registro de ponto: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public List<RegistroPonto> listar() {
        return listarTodos(); // redireciona pro novo método
    }

    public List<RegistroPonto> listarTodos() {
        List<RegistroPonto> lista = new ArrayList<>();
        try {
            this.conectar();
            String sql = "SELECT rp.*, f.idFfuncionario, f.nome FROM registro_ponto rp " +
                         "INNER JOIN funcionario f ON rp.funcionario_idFfuncionario = f.idFfuncionario";
            PreparedStatement pstm = this.conn.prepareStatement(sql);
            ResultSet rs = pstm.executeQuery();
            while (rs.next()) {
                RegistroPonto r = new RegistroPonto();
                r.setIdRegistro_ponto(rs.getInt("idRegistro_ponto"));
                r.setData(rs.getDate("data"));
                r.setHoraEntrada(rs.getTime("horaEntrada"));
                r.setHoraSaida(rs.getTime("horaSaida"));
                r.setFuncionario_idFfuncionario(rs.getInt("funcionario_idFfuncionario"));

                Funcionario f = new Funcionario();
                f.setIdFuncionario(rs.getInt("idFfuncionario"));
                f.setNome(rs.getString("nome"));
                r.setFuncionario(f);

                lista.add(r);
            }
            this.desconectar();
        } catch (Exception e) {
            System.out.println("Erro ao listar todos os registros de ponto: " + e.getMessage());
            e.printStackTrace();
        }
        return lista;
    }

    public List<RegistroPonto> listarPorFuncionario(int idFfuncionario) {
        List<RegistroPonto> lista = new ArrayList<>();
        try {
            this.conectar();
            String sql = "SELECT rp.*, f.idFfuncionario, f.nome FROM registro_ponto rp " +
                         "INNER JOIN funcionario f ON rp.funcionario_idFfuncionario = f.idFfuncionario " +
                         "WHERE rp.funcionario_idFfuncionario = ?";
            PreparedStatement pstm = this.conn.prepareStatement(sql);
            pstm.setInt(1, idFfuncionario);
            ResultSet rs = pstm.executeQuery();

            while (rs.next()) {
                RegistroPonto r = new RegistroPonto();
                r.setIdRegistro_ponto(rs.getInt("idRegistro_ponto"));
                r.setData(rs.getDate("data"));
                r.setHoraEntrada(rs.getTime("horaEntrada"));
                r.setHoraSaida(rs.getTime("horaSaida"));
                r.setFuncionario_idFfuncionario(idFfuncionario);

                Funcionario f = new Funcionario();
                f.setIdFuncionario(rs.getInt("idFfuncionario"));
                f.setNome(rs.getString("nome"));
                r.setFuncionario(f);

                lista.add(r);
            }
            this.desconectar();
        } catch (Exception e) {
            System.out.println("Erro ao listar pontos por funcionário: " + e.getMessage());
            e.printStackTrace();
        }
        return lista;
    }

    public boolean excluir(int idRegistro) {
        try {
            this.conectar();
            String sql = "DELETE FROM registro_ponto WHERE idRegistro_ponto=?";
            PreparedStatement pstm = this.conn.prepareStatement(sql);
            pstm.setInt(1, idRegistro);
            pstm.execute();
            this.desconectar();
            return true;
        } catch (Exception e) {
            System.out.println("Erro ao excluir registro de ponto: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public RegistroPonto getCarregaPorID(int idRegistro) {
        RegistroPonto r = new RegistroPonto();
        try {
            this.conectar();
            String sql = "SELECT * FROM registro_ponto WHERE idRegistro_ponto=?";
            PreparedStatement pstm = this.conn.prepareStatement(sql);
            pstm.setInt(1, idRegistro);
            ResultSet rs = pstm.executeQuery();
            if (rs.next()) {
                r.setIdRegistro_ponto(rs.getInt("idRegistro_ponto"));
                r.setData(rs.getDate("data"));
                r.setHoraEntrada(rs.getTime("horaEntrada"));
                r.setHoraSaida(rs.getTime("horaSaida"));
                r.setFuncionario_idFfuncionario(rs.getInt("funcionario_idFfuncionario"));
            }
            this.desconectar();
        } catch (Exception e) {
            System.out.println("Erro ao carregar registro de ponto: " + e.getMessage());
            e.printStackTrace();
        }
        return r;
    }

    public boolean gravarEntrada(RegistroPonto r) {
        try {
            this.conectar();
            String sql = "INSERT INTO registro_ponto (data, horaEntrada, funcionario_idFfuncionario) VALUES (?, ?, ?)";
            PreparedStatement pstm = this.conn.prepareStatement(sql);
            pstm.setDate(1, r.getData());
            pstm.setTime(2, r.getHoraEntrada());
            pstm.setInt(3, r.getFuncionario_idFfuncionario());
            pstm.execute();
            this.desconectar();
            return true;
        } catch (Exception e) {
            System.out.println("Erro ao gravar entrada de ponto: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public RegistroPonto getRegistroSemSaida(int idFuncionario, java.time.LocalDate data) {
        RegistroPonto r = null;
        try {
            this.conectar();
            String sql = "SELECT * FROM registro_ponto WHERE funcionario_idFfuncionario=? AND data=? AND horaSaida IS NULL";
            PreparedStatement pstm = this.conn.prepareStatement(sql);
            pstm.setInt(1, idFuncionario);
            pstm.setDate(2, java.sql.Date.valueOf(data));
            ResultSet rs = pstm.executeQuery();
            if (rs.next()) {
                r = new RegistroPonto();
                r.setIdRegistro_ponto(rs.getInt("idRegistro_ponto"));
                r.setData(rs.getDate("data"));
                r.setHoraEntrada(rs.getTime("horaEntrada"));
                r.setHoraSaida(rs.getTime("horaSaida"));
                r.setFuncionario_idFfuncionario(rs.getInt("funcionario_idFfuncionario"));
            }
            this.desconectar();
        } catch (Exception e) {
            System.out.println("Erro ao buscar registro sem saída: " + e.getMessage());
            e.printStackTrace();
        }
        return r;
    }

    public boolean atualizarSaida(RegistroPonto r) {
        try {
            this.conectar();
            String sql = "UPDATE registro_ponto SET horaSaida=? WHERE idRegistro_ponto=?";
            PreparedStatement pstm = this.conn.prepareStatement(sql);
            pstm.setTime(1, r.getHoraSaida());
            pstm.setInt(2, r.getIdRegistro_ponto());
            pstm.execute();
            this.desconectar();
            return true;
        } catch (Exception e) {
            System.out.println("Erro ao atualizar saída: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean temRegistroCompletoHoje(int idFuncionario, java.time.LocalDate data) {
        boolean tem = false;
        try {
            this.conectar();
            String sql = "SELECT COUNT(*) AS total FROM registro_ponto " +
                         "WHERE funcionario_idFfuncionario = ? AND data = ? AND horaEntrada IS NOT NULL AND horaSaida IS NOT NULL";
            PreparedStatement pstm = this.conn.prepareStatement(sql);
            pstm.setInt(1, idFuncionario);
            pstm.setDate(2, java.sql.Date.valueOf(data));
            ResultSet rs = pstm.executeQuery();
            if (rs.next()) {
                tem = rs.getInt("total") > 0;
            }
            this.desconectar();
        } catch (Exception e) {
            System.out.println("Erro ao verificar se já tem registro completo hoje: " + e.getMessage());
            e.printStackTrace();
        }
        return tem;
    }
}
