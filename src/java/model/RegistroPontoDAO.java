package model;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Time;
import java.sql.SQLException;

import java.time.LocalDate;
import java.time.LocalTime;
import java.time.temporal.ChronoUnit;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class RegistroPontoDAO extends DataBaseDAO {

    public RegistroPontoDAO() throws Exception {
        this.conectar();
    }

    public RegistroPonto getCarregaPorID(int idRegistro) throws Exception {
        this.conectar();
        RegistroPonto r = new RegistroPonto();
        String sql = "SELECT * FROM registro_ponto WHERE idRegistro_ponto = ?";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setInt(1, idRegistro);
        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            r.setIdRegistro_ponto(rs.getInt("idRegistro_ponto"));
            r.setData(rs.getDate("data").toLocalDate());
            r.setHoraEntrada(rs.getTime("horaEntrada").toLocalTime());
            r.setHoraAlmocoSaida(rs.getTime("horaAlmocoSaida") != null ? rs.getTime("horaAlmocoSaida").toLocalTime() : null);
            r.setHoraAlmocoVolta(rs.getTime("horaAlmocoVolta") != null ? rs.getTime("horaAlmocoVolta").toLocalTime() : null);
            r.setHoraSaida(rs.getTime("horaSaida") != null ? rs.getTime("horaSaida").toLocalTime() : null);
            r.setHorasTrabalhadas(rs.getBigDecimal("horasTrabalhadas") != null ? rs.getBigDecimal("horasTrabalhadas").doubleValue() : 0);
            int idFunc = rs.getInt("funcionario_idFfuncionario");
            r.setFuncionario_idFfuncionario(idFunc);

            FuncionarioDAO fdao = new FuncionarioDAO();
            fdao.conectar();
            r.setFuncionario(fdao.getCarregaPorID(idFunc));
        }

        this.desconectar();
        return r;
    }

    public boolean gravar(RegistroPonto r) throws Exception {
        this.conectar();
        String sql;
        if (r.getIdRegistro_ponto() == 0) {
            sql = "INSERT INTO registro_ponto (data, horaEntrada, horaAlmocoSaida, horaAlmocoVolta, horaSaida, horasTrabalhadas, funcionario_idFfuncionario) VALUES (?, ?, ?, ?, ?, ?, ?)";
        } else {
            sql = "UPDATE registro_ponto SET data=?, horaEntrada=?, horaAlmocoSaida=?, horaAlmocoVolta=?, horaSaida=?, horasTrabalhadas=?, funcionario_idFfuncionario=? WHERE idRegistro_ponto=?";
        }

        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setDate(1, Date.valueOf(r.getData()));
        stmt.setTime(2, Time.valueOf(r.getHoraEntrada()));
        stmt.setTime(3, r.getHoraAlmocoSaida() != null ? Time.valueOf(r.getHoraAlmocoSaida()) : null);
        stmt.setTime(4, r.getHoraAlmocoVolta() != null ? Time.valueOf(r.getHoraAlmocoVolta()) : null);
        stmt.setTime(5, r.getHoraSaida() != null ? Time.valueOf(r.getHoraSaida()) : null);
        stmt.setBigDecimal(6, new java.math.BigDecimal(r.getHorasTrabalhadas()));
        stmt.setInt(7, r.getFuncionario_idFfuncionario());

        if (r.getIdRegistro_ponto() > 0) {
            stmt.setInt(8, r.getIdRegistro_ponto());
        }

        stmt.execute();
        this.desconectar();
        return true;
    }

    public boolean excluir(int id) throws Exception {
        this.conectar();
        String sql = "DELETE FROM registro_ponto WHERE idRegistro_ponto=?";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setInt(1, id);
        stmt.execute();
        this.desconectar();
        return true;
    }

    public List<RegistroPonto> listarTodos() throws Exception {
        this.conectar();
        List<RegistroPonto> lista = new ArrayList<>();
        String sql = "SELECT * FROM registro_ponto ORDER BY data DESC, horaEntrada ASC";
        PreparedStatement stmt = conn.prepareStatement(sql);
        ResultSet rs = stmt.executeQuery();

        FuncionarioDAO fdao = new FuncionarioDAO();
        fdao.conectar();

        while (rs.next()) {
            RegistroPonto rp = new RegistroPonto();
            rp.setIdRegistro_ponto(rs.getInt("idRegistro_ponto"));
            rp.setData(rs.getDate("data").toLocalDate());
            rp.setHoraEntrada(rs.getTime("horaEntrada").toLocalTime());
            rp.setHoraAlmocoSaida(rs.getTime("horaAlmocoSaida") != null ? rs.getTime("horaAlmocoSaida").toLocalTime() : null);
            rp.setHoraAlmocoVolta(rs.getTime("horaAlmocoVolta") != null ? rs.getTime("horaAlmocoVolta").toLocalTime() : null);
            rp.setHoraSaida(rs.getTime("horaSaida") != null ? rs.getTime("horaSaida").toLocalTime() : null);
            rp.setHorasTrabalhadas(rs.getBigDecimal("horasTrabalhadas") != null ? rs.getBigDecimal("horasTrabalhadas").doubleValue() : 0);
            int idFunc = rs.getInt("funcionario_idFfuncionario");
            rp.setFuncionario_idFfuncionario(idFunc);
            rp.setFuncionario(fdao.getCarregaPorID(idFunc));
            lista.add(rp);
        }

        this.desconectar();
        return lista;
    }

    public List<RegistroPonto> listarPorFuncionario(int idFuncionario) throws Exception {
        this.conectar();
        List<RegistroPonto> lista = new ArrayList<>();
        String sql = "SELECT * FROM registro_ponto WHERE funcionario_idFfuncionario = ? ORDER BY data DESC, horaEntrada ASC";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setInt(1, idFuncionario);
        ResultSet rs = stmt.executeQuery();

        FuncionarioDAO fdao = new FuncionarioDAO();
        fdao.conectar();

        while (rs.next()) {
            RegistroPonto rp = new RegistroPonto();
            rp.setIdRegistro_ponto(rs.getInt("idRegistro_ponto"));
            rp.setData(rs.getDate("data").toLocalDate());
            rp.setHoraEntrada(rs.getTime("horaEntrada").toLocalTime());
            rp.setHoraAlmocoSaida(rs.getTime("horaAlmocoSaida") != null ? rs.getTime("horaAlmocoSaida").toLocalTime() : null);
            rp.setHoraAlmocoVolta(rs.getTime("horaAlmocoVolta") != null ? rs.getTime("horaAlmocoVolta").toLocalTime() : null);
            rp.setHoraSaida(rs.getTime("horaSaida") != null ? rs.getTime("horaSaida").toLocalTime() : null);
            rp.setHorasTrabalhadas(rs.getBigDecimal("horasTrabalhadas") != null ? rs.getBigDecimal("horasTrabalhadas").doubleValue() : 0);
            rp.setFuncionario_idFfuncionario(idFuncionario);
            rp.setFuncionario(fdao.getCarregaPorID(idFuncionario));
            lista.add(rp);
        }

        this.desconectar();
        return lista;
    }

    public int getIdFuncionarioPorUsuario(int idUsuario) throws Exception {
        this.conectar();
        String sql = "SELECT idFfuncionario FROM funcionario WHERE usuario_idUsuario = ?";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setInt(1, idUsuario);
        ResultSet rs = stmt.executeQuery();
        this.desconectar();
        if (rs.next()) {
            return rs.getInt("idFfuncionario");
        } else {
            throw new Exception("Funcionário não encontrado para o usuário de ID: " + idUsuario);
        }
    }

    public String registrarPonto(int idFuncionario) throws Exception {
        LocalDate hoje = LocalDate.now();
        LocalTime agora = LocalTime.now();

        List<RegistroPonto> registros = listarPorFuncionario(idFuncionario);
        Optional<RegistroPonto> registroHojeOpt = registros.stream()
            .filter(r -> r.getData().equals(hoje))
            .findFirst();

        RegistroPonto registro;
        if (registroHojeOpt.isPresent()) {
            registro = registroHojeOpt.get();
        } else {
            registro = new RegistroPonto();
            registro.setData(hoje);
            registro.setFuncionario_idFfuncionario(idFuncionario);
        }

        if (registro.getHoraEntrada() == null) {
            registro.setHoraEntrada(agora);
            gravar(registro);
            return "Entrada registrada com sucesso!";
        } else if (registro.getHoraAlmocoSaida() == null) {
            registro.setHoraAlmocoSaida(agora);
            gravar(registro);
            return "Saída para almoço registrada com sucesso!";
        } else if (registro.getHoraAlmocoVolta() == null) {
            registro.setHoraAlmocoVolta(agora);
            gravar(registro);
            return "Volta do almoço registrada com sucesso!";
        } else if (registro.getHoraSaida() == null) {
            registro.setHoraSaida(agora);

            long minutosManha = ChronoUnit.MINUTES.between(registro.getHoraEntrada(), registro.getHoraAlmocoSaida());
            long minutosTarde = ChronoUnit.MINUTES.between(registro.getHoraAlmocoVolta(), registro.getHoraSaida());
            double totalHoras = (minutosManha + minutosTarde) / 60.0;
            registro.setHorasTrabalhadas(totalHoras);

            gravar(registro);
            return "Saída registrada com sucesso! Total de horas: " + totalHoras + "h";
        } else {
            return "As 4 marcações de ponto já foram registradas hoje.";
        }
    }

    // NOVOS MÉTODOS DE RESUMO MENSAL:

    public double getTotalHorasTrabalhadasMes(int idFuncionario, int mes, int ano) throws Exception {
        this.conectar();
        String sql = "SELECT SUM(horasTrabalhadas) AS total FROM registro_ponto " +
                     "WHERE funcionario_idFfuncionario = ? AND MONTH(data) = ? AND YEAR(data) = ?";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setInt(1, idFuncionario);
        stmt.setInt(2, mes);
        stmt.setInt(3, ano);
        ResultSet rs = stmt.executeQuery();
        double total = 0.0;
        if (rs.next()) {
            total = rs.getDouble("total");
        }
        this.desconectar();
        return total;
    }

    public int getDiasComRegistro(int idFuncionario, int mes, int ano) throws Exception {
        this.conectar();
        String sql = "SELECT COUNT(DISTINCT data) AS dias FROM registro_ponto " +
                     "WHERE funcionario_idFfuncionario = ? AND MONTH(data) = ? AND YEAR(data) = ?";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setInt(1, idFuncionario);
        stmt.setInt(2, mes);
        stmt.setInt(3, ano);
        ResultSet rs = stmt.executeQuery();
        int dias = 0;
        if (rs.next()) {
            dias = rs.getInt("dias");
        }
        this.desconectar();
        return dias;
    }
    
     
    //Barra de busca
   public List<RegistroPonto> buscarPorTermo(String termo) throws Exception {
    List<RegistroPonto> lista = new ArrayList<>();

    String[] palavras = termo.trim().split("\\s+");  // Divide o termo por espaços

    StringBuilder sql = new StringBuilder();
    sql.append("SELECT rp.*, f.nome AS nome_funcionario FROM registro_ponto rp ");
    sql.append("INNER JOIN funcionario f ON f.idFfuncionario = rp.funcionario_idFfuncionario ");
    sql.append("WHERE 1=1 ");

    for (String palavra : palavras) {
        sql.append("AND (");
        sql.append("CAST(rp.idRegistro_ponto AS CHAR) LIKE ? OR ");
        sql.append("CAST(rp.data AS CHAR) LIKE ? OR ");
        sql.append("CAST(rp.horaEntrada AS CHAR) LIKE ? OR ");
        sql.append("CAST(rp.horaAlmocoSaida AS CHAR) LIKE ? OR ");
        sql.append("CAST(rp.horaAlmocoVolta AS CHAR) LIKE ? OR ");
        sql.append("CAST(rp.horaSaida AS CHAR) LIKE ? OR ");
        sql.append("CAST(rp.horasTrabalhadas AS CHAR) LIKE ? OR ");
        sql.append("f.nome LIKE ? ");
        sql.append(") ");
    }

    this.conectar();
    try (PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
        int paramIndex = 1;
        for (String palavra : palavras) {
            String filtro = "%" + palavra + "%";
            for (int i = 0; i < 8; i++) {  // 8 campos por palavra
                stmt.setString(paramIndex++, filtro);
            }
        }

        ResultSet rs = stmt.executeQuery();
        FuncionarioDAO fdao = new FuncionarioDAO();
        fdao.conectar();

        while (rs.next()) {
            RegistroPonto rp = new RegistroPonto();
            rp.setIdRegistro_ponto(rs.getInt("idRegistro_ponto"));
            rp.setData(rs.getDate("data").toLocalDate());
            rp.setHoraEntrada(rs.getTime("horaEntrada") != null ? rs.getTime("horaEntrada").toLocalTime() : null);
            rp.setHoraAlmocoSaida(rs.getTime("horaAlmocoSaida") != null ? rs.getTime("horaAlmocoSaida").toLocalTime() : null);
            rp.setHoraAlmocoVolta(rs.getTime("horaAlmocoVolta") != null ? rs.getTime("horaAlmocoVolta").toLocalTime() : null);
            rp.setHoraSaida(rs.getTime("horaSaida") != null ? rs.getTime("horaSaida").toLocalTime() : null);
            rp.setHorasTrabalhadas(rs.getBigDecimal("horasTrabalhadas") != null ? rs.getBigDecimal("horasTrabalhadas").doubleValue() : 0);
            int idFunc = rs.getInt("funcionario_idFfuncionario");
            rp.setFuncionario_idFfuncionario(idFunc);
            rp.setFuncionario(fdao.getCarregaPorID(idFunc));
            lista.add(rp);
        }
    } finally {
        this.desconectar();
    }

    return lista;
}

    
}
