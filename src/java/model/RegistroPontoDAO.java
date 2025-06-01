package model;


import java.time.*;
import java.time.temporal.ChronoUnit;
import java.util.*;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Time;
import java.sql.Date; // usa esse pra evitar conflito explícito


public class RegistroPontoDAO extends DataBaseDAO {

    public RegistroPontoDAO() throws Exception {
        this.conectar();
    }

    public RegistroPonto getCarregaPorID(int idRegistro) throws Exception {
        RegistroPonto r = new RegistroPonto();
        String sql = "SELECT * FROM registro_ponto WHERE idRegistro_ponto = ?";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setInt(1, idRegistro);
        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            r.setIdRegistro_ponto(rs.getInt("idRegistro_ponto"));
            r.setData(rs.getDate("data").toLocalDate());
            r.setHoraEntrada(rs.getTime("horaEntrada").toLocalTime());
            r.setHoraSaidaAlmoco(rs.getTime("horaSaidaAlmoco") != null ? rs.getTime("horaSaidaAlmoco").toLocalTime() : null);
            r.setHoraVoltaAlmoco(rs.getTime("horaVoltaAlmoco") != null ? rs.getTime("horaVoltaAlmoco").toLocalTime() : null);
            r.setHoraSaidaFinal(rs.getTime("horaSaidaFinal") != null ? rs.getTime("horaSaidaFinal").toLocalTime() : null);
            r.setHorasTrabalhadas(rs.getBigDecimal("horasTrabalhadas") != null ? rs.getBigDecimal("horasTrabalhadas").doubleValue() : 0);
            int idFunc = rs.getInt("funcionario_idFfuncionario");
            r.setFuncionario_idFfuncionario(idFunc);

            FuncionarioDAO fdao = new FuncionarioDAO();
            fdao.conectar();
            r.setFuncionario(fdao.getCarregaPorID(idFunc));
        }

        return r;
    }

    public boolean gravar(RegistroPonto r) throws Exception {
        this.conectar();
        String sql;
        if (r.getIdRegistro_ponto() == 0) {
            sql = "INSERT INTO registro_ponto (data, horaEntrada, horaSaidaAlmoco, horaVoltaAlmoco, horaSaidaFinal, horasTrabalhadas, funcionario_idFfuncionario) VALUES (?, ?, ?, ?, ?, ?, ?)";
        } else {
            sql = "UPDATE registro_ponto SET data=?, horaEntrada=?, horaSaidaAlmoco=?, horaVoltaAlmoco=?, horaSaidaFinal=?, horasTrabalhadas=?, funcionario_idFfuncionario=? WHERE idRegistro_ponto=?";
        }

        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setDate(1, Date.valueOf(r.getData()));
        stmt.setTime(2, Time.valueOf(r.getHoraEntrada()));
        stmt.setTime(3, r.getHoraSaidaAlmoco() != null ? Time.valueOf(r.getHoraSaidaAlmoco()) : null);
        stmt.setTime(4, r.getHoraVoltaAlmoco() != null ? Time.valueOf(r.getHoraVoltaAlmoco()) : null);
        stmt.setTime(5, r.getHoraSaidaFinal() != null ? Time.valueOf(r.getHoraSaidaFinal()) : null);
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
            rp.setHoraSaidaAlmoco(rs.getTime("horaSaidaAlmoco") != null ? rs.getTime("horaSaidaAlmoco").toLocalTime() : null);
            rp.setHoraVoltaAlmoco(rs.getTime("horaVoltaAlmoco") != null ? rs.getTime("horaVoltaAlmoco").toLocalTime() : null);
            rp.setHoraSaidaFinal(rs.getTime("horaSaidaFinal") != null ? rs.getTime("horaSaidaFinal").toLocalTime() : null);
            rp.setHorasTrabalhadas(rs.getBigDecimal("horasTrabalhadas") != null ? rs.getBigDecimal("horasTrabalhadas").doubleValue() : 0);
            int idFunc = rs.getInt("funcionario_idFfuncionario");
            rp.setFuncionario_idFfuncionario(idFunc);
            rp.setFuncionario(fdao.getCarregaPorID(idFunc));
            lista.add(rp);
        }

        return lista;
    }

    public List<RegistroPonto> listarPorFuncionario(int idFuncionario) throws Exception {
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
            rp.setHoraSaidaAlmoco(rs.getTime("horaSaidaAlmoco") != null ? rs.getTime("horaSaidaAlmoco").toLocalTime() : null);
            rp.setHoraVoltaAlmoco(rs.getTime("horaVoltaAlmoco") != null ? rs.getTime("horaVoltaAlmoco").toLocalTime() : null);
            rp.setHoraSaidaFinal(rs.getTime("horaSaidaFinal") != null ? rs.getTime("horaSaidaFinal").toLocalTime() : null);
            rp.setHorasTrabalhadas(rs.getBigDecimal("horasTrabalhadas") != null ? rs.getBigDecimal("horasTrabalhadas").doubleValue() : 0);
            rp.setFuncionario_idFfuncionario(idFuncionario);
            rp.setFuncionario(fdao.getCarregaPorID(idFuncionario));
            lista.add(rp);
        }

        return lista;
    }

    public int getIdFuncionarioPorUsuario(int idUsuario) throws Exception {
        String sql = "SELECT idFfuncionario FROM funcionario WHERE usuario_idUsuario = ?";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setInt(1, idUsuario);
        ResultSet rs = stmt.executeQuery();
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
        } else if (registro.getHoraSaidaAlmoco() == null) {
            registro.setHoraSaidaAlmoco(agora);
            gravar(registro);
            return "Saída para almoço registrada com sucesso!";
        } else if (registro.getHoraVoltaAlmoco() == null) {
            registro.setHoraVoltaAlmoco(agora);
            gravar(registro);
            return "Volta do almoço registrada com sucesso!";
        } else if (registro.getHoraSaidaFinal() == null) {
            registro.setHoraSaidaFinal(agora);

            long minutosManha = ChronoUnit.MINUTES.between(registro.getHoraEntrada(), registro.getHoraSaidaAlmoco());
            long minutosTarde = ChronoUnit.MINUTES.between(registro.getHoraVoltaAlmoco(), registro.getHoraSaidaFinal());
            double totalHoras = (minutosManha + minutosTarde) / 60.0;
            registro.setHorasTrabalhadas(totalHoras);

            gravar(registro);
            return "Saída registrada com sucesso! Total de horas: " + totalHoras + "h";
        } else {
            return "As 4 marcações de ponto já foram registradas hoje.";
        }
    }
}
