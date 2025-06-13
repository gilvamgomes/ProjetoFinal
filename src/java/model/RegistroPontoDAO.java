package model;

import java.sql.*;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.temporal.ChronoUnit;
import java.util.*;
import java.math.BigDecimal;  // IMPORT FUNDAMENTAL PARA BigDecimal
import java.sql.Date;

public class RegistroPontoDAO extends DataBaseDAO {

    public RegistroPontoDAO() throws Exception {
        // Não chamamos this.conectar() no construtor: cada método abre/conecta quando precisar.
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
            r.setData(rs.getDate("data") != null
                        ? rs.getDate("data").toLocalDate()
                        : null);
            r.setHoraEntrada(rs.getTime("horaEntrada") != null
                        ? rs.getTime("horaEntrada").toLocalTime()
                        : null);
            r.setHoraAlmocoSaida(rs.getTime("horaAlmocoSaida") != null
                        ? rs.getTime("horaAlmocoSaida").toLocalTime()
                        : null);
            r.setHoraAlmocoVolta(rs.getTime("horaAlmocoVolta") != null
                        ? rs.getTime("horaAlmocoVolta").toLocalTime()
                        : null);
            r.setHoraSaida(rs.getTime("horaSaida") != null
                        ? rs.getTime("horaSaida").toLocalTime()
                        : null);

            // Converte do campo DECIMAL(5,2) para double
            r.setHorasTrabalhadas(
                rs.getBigDecimal("horasTrabalhadas") != null
                    ? rs.getBigDecimal("horasTrabalhadas").doubleValue()
                    : 0.0
            );

            int idFunc = rs.getInt("funcionario_idFfuncionario");
            r.setFuncionario_idFfuncionario(idFunc);

            // Carrega o objeto Funcionario completo (opcional)
            FuncionarioDAO fdao = new FuncionarioDAO();
            r.setFuncionario(fdao.getCarregaPorID(idFunc));
        }

        this.desconectar();
        return r;
    }

    public boolean gravar(RegistroPonto r) throws Exception {
        this.conectar();
        String sql;

        if (r.getIdRegistro_ponto() == 0) {
            sql = 
              "INSERT INTO registro_ponto " +
              "(data, horaEntrada, horaAlmocoSaida, horaAlmocoVolta, horaSaida, horasTrabalhadas, funcionario_idFfuncionario) " +
              "VALUES (?, ?, ?, ?, ?, ?, ?)";
        } else {
            sql = 
              "UPDATE registro_ponto SET " +
              "data=?, horaEntrada=?, horaAlmocoSaida=?, horaAlmocoVolta=?, horaSaida=?, horasTrabalhadas=?, funcionario_idFfuncionario=? " +
              "WHERE idRegistro_ponto=?";
        }

        PreparedStatement stmt = conn.prepareStatement(sql);

        // =========================
        // 1) Campo DATA (DATE)
        // =========================
        if (r.getData() != null) {
            // Se r.getData() (LocalDate) não for nulo, converte para java.sql.Date
            stmt.setDate(1, Date.valueOf(r.getData()));
        } else {
            // Se for nulo, escreve NULL no banco
            stmt.setNull(1, Types.DATE);
        }

        // =========================
        // 2) horaEntrada (TIME)
        // =========================
        if (r.getHoraEntrada() != null) {
            stmt.setTime(2, Time.valueOf(r.getHoraEntrada()));
        } else {
            stmt.setNull(2, Types.TIME);
        }

        // ================================
        // 3) horaAlmocoSaida (TIME) / horaAlmocoVolta / horaSaida
        // ================================
        if (r.getHoraAlmocoSaida() != null) {
            stmt.setTime(3, Time.valueOf(r.getHoraAlmocoSaida()));
        } else {
            stmt.setNull(3, Types.TIME);
        }

        if (r.getHoraAlmocoVolta() != null) {
            stmt.setTime(4, Time.valueOf(r.getHoraAlmocoVolta()));
        } else {
            stmt.setNull(4, Types.TIME);
        }

        if (r.getHoraSaida() != null) {
            stmt.setTime(5, Time.valueOf(r.getHoraSaida()));
        } else {
            stmt.setNull(5, Types.TIME);
        }

        // ==================================
        // 4) horasTrabalhadas (DECIMAL)
        // ==================================
        // Se for zero, gravamos NULL; caso contrário, convertemos para BigDecimal
        if (r.getHorasTrabalhadas() != 0.0) {
            stmt.setBigDecimal(6, BigDecimal.valueOf(r.getHorasTrabalhadas()));
        } else {
            stmt.setNull(6, Types.DECIMAL);
        }

        // ==================================================
        // 5) funcionario_idFfuncionario (INT NOT NULL)
        // ==================================================
        stmt.setInt(7, r.getFuncionario_idFfuncionario());

        // ==================================================
        // 6) Se for UPDATE, o parâmetro final é o próprio ID
        // ==================================================
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

        while (rs.next()) {
            RegistroPonto rp = new RegistroPonto();
            rp.setIdRegistro_ponto(rs.getInt("idRegistro_ponto"));
            rp.setData(rs.getDate("data") != null
                        ? rs.getDate("data").toLocalDate()
                        : null);
            rp.setHoraEntrada(rs.getTime("horaEntrada") != null
                        ? rs.getTime("horaEntrada").toLocalTime()
                        : null);
            rp.setHoraAlmocoSaida(rs.getTime("horaAlmocoSaida") != null
                        ? rs.getTime("horaAlmocoSaida").toLocalTime()
                        : null);
            rp.setHoraAlmocoVolta(rs.getTime("horaAlmocoVolta") != null
                        ? rs.getTime("horaAlmocoVolta").toLocalTime()
                        : null);
            rp.setHoraSaida(rs.getTime("horaSaida") != null
                        ? rs.getTime("horaSaida").toLocalTime()
                        : null);

           rp.setHorasTrabalhadas(
               rs.getBigDecimal("horasTrabalhadas") != null
                   ? rs.getBigDecimal("horasTrabalhadas").doubleValue()
                   : 0.0
           );

            int idFunc = rs.getInt("funcionario_idFfuncionario");
            rp.setFuncionario_idFfuncionario(idFunc);

            // Carrega objeto Funcionario
            FuncionarioDAO fdao = new FuncionarioDAO();
            rp.setFuncionario(fdao.getCarregaPorID(idFunc));

            lista.add(rp);
        }

        this.desconectar();
        return lista;
    }

    public List<RegistroPonto> listarPorFuncionario(int idFuncionario) throws Exception {
        this.conectar();
        List<RegistroPonto> lista = new ArrayList<>();
        String sql = 
            "SELECT * FROM registro_ponto " +
            "WHERE funcionario_idFfuncionario = ? " +
            "ORDER BY data DESC, horaEntrada ASC";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setInt(1, idFuncionario);
        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            RegistroPonto rp = new RegistroPonto();
            rp.setIdRegistro_ponto(rs.getInt("idRegistro_ponto"));
            rp.setData(rs.getDate("data") != null
                        ? rs.getDate("data").toLocalDate()
                        : null);
            rp.setHoraEntrada(rs.getTime("horaEntrada") != null
                        ? rs.getTime("horaEntrada").toLocalTime()
                        : null);
            rp.setHoraAlmocoSaida(rs.getTime("horaAlmocoSaida") != null
                        ? rs.getTime("horaAlmocoSaida").toLocalTime()
                        : null);
            rp.setHoraAlmocoVolta(rs.getTime("horaAlmocoVolta") != null
                        ? rs.getTime("horaAlmocoVolta").toLocalTime()
                        : null);
            rp.setHoraSaida(rs.getTime("horaSaida") != null
                        ? rs.getTime("horaSaida").toLocalTime()
                        : null);

            rp.setHorasTrabalhadas(
                rs.getBigDecimal("horasTrabalhadas") != null
                    ? rs.getBigDecimal("horasTrabalhadas").doubleValue()
                    : 0.0
            );

            rp.setFuncionario_idFfuncionario(idFuncionario);

            FuncionarioDAO fdao = new FuncionarioDAO();
            rp.setFuncionario(fdao.getCarregaPorID(idFuncionario));

            lista.add(rp);
        }

        this.desconectar();
        return lista;
    }

    public int getIdFuncionarioPorUsuario(int idUsuario) throws Exception {
        this.conectar();
        String sql = 
            "SELECT idFfuncionario FROM funcionario WHERE usuario_idUsuario = ?";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setInt(1, idUsuario);
        ResultSet rs = stmt.executeQuery();

        int idF = -1;
        if (rs.next()) {
            idF = rs.getInt("idFfuncionario");
        }
        this.desconectar();

        if (idF < 0) {
            throw new Exception("Funcionário não encontrado para o usuário de ID: " + idUsuario);
        }
        return idF;
    }

    public String registrarPonto(int idFuncionario) throws Exception {
        LocalDate hoje = LocalDate.now();
        LocalTime agora = LocalTime.now();

        // Busca todas as marcações já feitas esse mês
        List<RegistroPonto> registros = listarPorFuncionario(idFuncionario);
        Optional<RegistroPonto> registroHojeOpt = registros.stream()
            .filter(r -> hoje.equals(r.getData()))
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
        } 
        else if (registro.getHoraAlmocoSaida() == null) {
            registro.setHoraAlmocoSaida(agora);
            gravar(registro);
            return "Saída para almoço registrada com sucesso!";
        } 
        else if (registro.getHoraAlmocoVolta() == null) {
            registro.setHoraAlmocoVolta(agora);
            gravar(registro);
            return "Volta do almoço registrada com sucesso!";
        } 
        else if (registro.getHoraSaida() == null) {
            registro.setHoraSaida(agora);

            // Se houver todas as 4 marcações, calcula horas trabalhadas
            if (registro.getHoraEntrada() != null &&
                registro.getHoraAlmocoSaida() != null &&
                registro.getHoraAlmocoVolta() != null &&
                registro.getHoraSaida() != null) {

                long minutosManha = ChronoUnit.MINUTES.between(
                    registro.getHoraEntrada(), 
                    registro.getHoraAlmocoSaida()
                );
                long minutosTarde = ChronoUnit.MINUTES.between(
                    registro.getHoraAlmocoVolta(), 
                    registro.getHoraSaida()
                );
                double totalHoras = (minutosManha + minutosTarde) / 60.0;
                registro.setHorasTrabalhadas(totalHoras);
            }

            gravar(registro);
            return "Saída registrada com sucesso!";
        } 
        else {
            return "As 4 marcações de ponto já foram registradas hoje.";
        }
    }

    public double getTotalHorasTrabalhadasMes(int idFuncionario, int mes, int ano) throws Exception {
        this.conectar();
        String sql = 
            "SELECT data, horaEntrada, horaAlmocoSaida, horaAlmocoVolta, horaSaida " +
            "FROM registro_ponto " +
            "WHERE funcionario_idFfuncionario = ? " +
            "  AND MONTH(data) = ? " +
            "  AND YEAR(data) = ?";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setInt(1, idFuncionario);
        stmt.setInt(2, mes);
        stmt.setInt(3, ano);
        ResultSet rs = stmt.executeQuery();

        double totalHoras = 0.0;

        while (rs.next()) {
            LocalDate data = rs.getDate("data").toLocalDate();
            LocalTime entrada = rs.getTime("horaEntrada").toLocalTime();
            LocalTime almocoSaida = rs.getTime("horaAlmocoSaida") != null
                ? rs.getTime("horaAlmocoSaida").toLocalTime()
                : null;
            LocalTime almocoVolta = rs.getTime("horaAlmocoVolta") != null
                ? rs.getTime("horaAlmocoVolta").toLocalTime()
                : null;
            LocalTime saida = rs.getTime("horaSaida").toLocalTime();

            double horasDia = 0.0;
            if (almocoSaida != null && almocoVolta != null) {
                long minutosManha = ChronoUnit.MINUTES.between(entrada, almocoSaida);
                long minutosTarde = ChronoUnit.MINUTES.between(almocoVolta, saida);
                horasDia = (minutosManha + minutosTarde) / 60.0;
            } else {
                long minutos = ChronoUnit.MINUTES.between(entrada, saida);
                horasDia = minutos / 60.0;
            }

            // Se for sábado (valor 6), conta no máximo 4h
            if (data.getDayOfWeek().getValue() == 6) {
                totalHoras += Math.min(horasDia, 4.0);
            } else {
                totalHoras += horasDia;
            }
        }

        this.desconectar();
        return totalHoras;
    }

    public int getDiasComRegistro(int idFuncionario, int mes, int ano) throws Exception {
        this.conectar();
        String sql = 
            "SELECT COUNT(DISTINCT data) AS dias " +
            "FROM registro_ponto " +
            "WHERE funcionario_idFfuncionario = ? " +
            "  AND MONTH(data) = ? " +
            "  AND YEAR(data) = ?";
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
}
