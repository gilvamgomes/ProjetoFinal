package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Date;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;
import utils.FeriadoUtils;
import utils.HorasUtils;

/**
 * DAO responsável por todas as operações de CRUD e geração de contra-cheque.
 */
public class ContraChequeDAO extends DataBaseDAO {

    public ContraChequeDAO() throws Exception {}

    public List<ContraCheque> getLista() throws SQLException {
        List<ContraCheque> lista = new ArrayList<>();
        String SQL = "SELECT c.*, f.nome AS nomeFuncionario " +
                     "FROM contra_cheque c " +
                     "JOIN funcionario f ON f.idFfuncionario = c.funcionario_idFfuncionario";

        try {
            this.conectar();
            PreparedStatement pstm = conn.prepareStatement(SQL);
            ResultSet rs = pstm.executeQuery();

            while (rs.next()) {
                ContraCheque c = new ContraCheque();
                c.setIdContraCheque(rs.getInt("idContra_cheque"));
                c.setValorBruto(rs.getBigDecimal("valorBruto"));
                c.setDescontos(rs.getBigDecimal("descontos"));
                c.setValorLiquido(rs.getBigDecimal("valorLiquido"));
                c.setFuncionarioId(rs.getInt("funcionario_idFfuncionario"));
                c.setMes(rs.getInt("mes"));
                c.setAno(rs.getInt("ano"));
                c.setNomeFuncionario(rs.getString("nomeFuncionario"));
                lista.add(c);
            }
        } catch (SQLException e) {
            throw new SQLException("Erro ao buscar contra-cheques: " + e.getMessage(), e);
        } finally {
            this.desconectar();
        }
        return lista;
    }

    public boolean gravar(ContraCheque c) {
        try {
            this.conectar();
            String sql;
            PreparedStatement pstm;

            if (c.getIdContraCheque() == 0) {
                sql = "INSERT INTO contra_cheque " +
                      "(valorBruto, descontos, valorLiquido, funcionario_idFfuncionario, mes, ano) " +
                      "VALUES (?, ?, ?, ?, ?, ?)";
                pstm = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
                pstm.setBigDecimal(1, c.getValorBruto());
                pstm.setBigDecimal(2, c.getDescontos());
                pstm.setBigDecimal(3, c.getValorLiquido());
                pstm.setInt(4, c.getFuncionarioId());
                pstm.setInt(5, c.getMes());
                pstm.setInt(6, c.getAno());
                pstm.executeUpdate();

                ResultSet rs = pstm.getGeneratedKeys();
                if (rs.next()) {
                    c.setIdContraCheque(rs.getInt(1));
                }
            } else {
                sql = "UPDATE contra_cheque SET " +
                      "valorBruto=?, descontos=?, valorLiquido=?, funcionario_idFfuncionario=?, mes=?, ano=? " +
                      "WHERE idContra_cheque=?";
                pstm = conn.prepareStatement(sql);
                pstm.setBigDecimal(1, c.getValorBruto());
                pstm.setBigDecimal(2, c.getDescontos());
                pstm.setBigDecimal(3, c.getValorLiquido());
                pstm.setInt(4, c.getFuncionarioId());
                pstm.setInt(5, c.getMes());
                pstm.setInt(6, c.getAno());
                pstm.setInt(7, c.getIdContraCheque());
                pstm.executeUpdate();
            }

            this.desconectar();
            return true;
        } catch (SQLException e) {
            System.err.println("Erro ao gravar: " + e.getMessage());
            return false;
        }
    }

    public ContraCheque getCarregaPorID(int idContraCheque) throws Exception {
        ContraCheque c = new ContraCheque();
        String sql = "SELECT c.*, f.nome AS nomeFuncionario " +
                     "FROM contra_cheque c " +
                     "JOIN funcionario f ON f.idFfuncionario = c.funcionario_idFfuncionario " +
                     "WHERE c.idContra_cheque = ?";

        this.conectar();
        PreparedStatement pstm = conn.prepareStatement(sql);
        pstm.setInt(1, idContraCheque);
        ResultSet rs = pstm.executeQuery();

        if (rs.next()) {
            c.setIdContraCheque(rs.getInt("idContra_cheque"));
            c.setValorBruto(rs.getBigDecimal("valorBruto"));
            c.setDescontos(rs.getBigDecimal("descontos"));
            c.setValorLiquido(rs.getBigDecimal("valorLiquido"));
            c.setFuncionarioId(rs.getInt("funcionario_idFfuncionario"));
            c.setMes(rs.getInt("mes"));
            c.setAno(rs.getInt("ano"));
            c.setNomeFuncionario(rs.getString("nomeFuncionario"));
        }

        this.desconectar();
        return c;
    }

    public boolean excluir(ContraCheque c) {
        try {
            this.conectar();

            PreparedStatement stmtEventos = conn.prepareStatement(
                "DELETE FROM evento_contra_cheque WHERE idContra_cheque = ?");
            stmtEventos.setInt(1, c.getIdContraCheque());
            stmtEventos.executeUpdate();

            PreparedStatement stmtImpostos = conn.prepareStatement(
                "DELETE FROM contra_cheque_imposto WHERE idContra_cheque = ?");
            stmtImpostos.setInt(1, c.getIdContraCheque());
            stmtImpostos.executeUpdate();

            PreparedStatement stmtCC = conn.prepareStatement(
                "DELETE FROM contra_cheque WHERE idContra_cheque = ?");
            stmtCC.setInt(1, c.getIdContraCheque());
            stmtCC.executeUpdate();

            this.desconectar();
            return true;
        } catch (SQLException e) {
            System.err.println("Erro ao excluir contra-cheque: " + e.getMessage());
            return false;
        }
    }

    public BigDecimal getTotalBeneficiosAtivos(int funcionarioId) throws Exception {
        this.conectar();
        PreparedStatement stmt = conn.prepareStatement(
            "SELECT SUM(fb.valor) AS total " +
            "FROM funcionario_beneficio fb " +
            "JOIN beneficio b ON fb.beneficio_idBeneficio = b.idBeneficio " +
            "WHERE fb.funcionario_idFfuncionario = ? AND b.status = 1");
        stmt.setInt(1, funcionarioId);
        ResultSet rs = stmt.executeQuery();

        BigDecimal total = BigDecimal.ZERO;
        if (rs.next() && rs.getBigDecimal("total") != null) {
            total = rs.getBigDecimal("total");
        }

        this.desconectar();
        return total;
    }

    public void registrarEvento(int contraChequeId, String descricao, BigDecimal valor, boolean ehDesconto) throws Exception {
        this.conectar();
        PreparedStatement stmt = conn.prepareStatement(
            "INSERT INTO evento_contra_cheque " +
            "(descricao, valor, tipo, idContra_cheque) VALUES (?, ?, ?, ?)");
        stmt.setString(1, descricao);
        stmt.setBigDecimal(2, valor);
        stmt.setString(3, ehDesconto ? "DESCONTO" : "VENCIMENTO");
        stmt.setInt(4, contraChequeId);
        stmt.execute();
        this.desconectar();
    }

    public void registrarImposto(int contraChequeId, int idImposto, BigDecimal valor) {
        String sql = "INSERT INTO contra_cheque_imposto " +
                     "(idContra_cheque, idImposto, valorDescontado) VALUES (?, ?, ?)";
        try {
            this.conectar();
            conn.setAutoCommit(false);

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, contraChequeId);
                ps.setInt(2, idImposto);
                ps.setBigDecimal(3, valor);

                int rows = ps.executeUpdate();
                System.out.println("registrarImposto(): inseriu " + rows + " linha(s) para ID=" + contraChequeId);

                conn.commit();
                System.out.println("registrarImposto(): commit OK para ID=" + contraChequeId);
            }
        } catch (SQLException e) {
            try {
                conn.rollback();
                System.err.println("registrarImposto(): rollback para ID=" + contraChequeId);
            } catch (SQLException ex) {
                System.err.println("Erro no rollback: " + ex.getMessage());
            }
            System.err.println("Erro em registrarImposto (ID=" + contraChequeId + "): " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                conn.setAutoCommit(true);
                this.desconectar();
            } catch (Exception ex) {
                System.err.println("Erro ao desconectar após registrarImposto: " + ex.getMessage());
            }
        }
    }

    public List<EventoContraCheque> getEventosPorContraCheque(int contraChequeId) throws Exception {
        List<EventoContraCheque> lista = new ArrayList<>();
        this.conectar();
        PreparedStatement stmt = conn.prepareStatement(
            "SELECT * FROM evento_contra_cheque WHERE idContra_cheque = ?");
        stmt.setInt(1, contraChequeId);
        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            EventoContraCheque e = new EventoContraCheque();
            e.setDescricao(rs.getString("descricao"));
            e.setValor(rs.getBigDecimal("valor"));
            e.setEhDesconto("DESCONTO".equalsIgnoreCase(rs.getString("tipo")));
            lista.add(e);
        }

        this.desconectar();
        return lista;
    }

    public List<Imposto> getImpostosPorContraCheque(int contraChequeId) throws Exception {
        List<Imposto> lista = new ArrayList<>();
        this.conectar();
        String sql = 
            "SELECT i.idImposto, i.descricao, i.tipo, " +
            "i.faixa_inicio AS faixaInicio, i.faixa_fim AS faixaFim, " +
            "i.aliquota, i.parcela_deduzir AS parcelaDeduzir, " +
            "cci.valorDescontado " +
            "FROM contra_cheque_imposto cci " +
            "JOIN imposto i ON i.idImposto = cci.idImposto " +
            "WHERE cci.idContra_cheque = ?";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setInt(1, contraChequeId);
        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            Imposto i = new Imposto();
            i.setIdImposto(rs.getInt("idImposto"));
            i.setDescricao(rs.getString("descricao"));
            i.setTipo(rs.getString("tipo"));
            i.setFaixaInicio(rs.getBigDecimal("faixaInicio"));
            i.setFaixaFim(rs.getBigDecimal("faixaFim"));
            i.setAliquota(rs.getBigDecimal("aliquota"));
            i.setParcelaDeduzir(rs.getBigDecimal("parcelaDeduzir"));
            i.setValorDescontado(rs.getBigDecimal("valorDescontado"));
            lista.add(i);
        }

        this.desconectar();
        return lista;
    }

    public boolean gerarContraCheque(int funcionarioId, int ano, int mes, boolean trabalhaSabado, double horasTrabalhadas) throws Exception {
        PagamentoDAO pDAO = new PagamentoDAO();
        BigDecimal salarioBase = BigDecimal.valueOf(pDAO.getUltimoSalario(funcionarioId));

        List<LocalDate> feriados = FeriadoUtils.buscarFeriadosRelevantes(ano, "DF");
        double horasEsperadas = HorasUtils.calcularHorasEsperadasMes(ano, mes, feriados, trabalhaSabado);

        BigDecimal valorHora = salarioBase
            .divide(BigDecimal.valueOf(horasEsperadas), 2, BigDecimal.ROUND_HALF_UP);

        BigDecimal desconto = BigDecimal.ZERO;
        BigDecimal adicional = BigDecimal.ZERO;
        if (horasTrabalhadas < horasEsperadas) {
            desconto = valorHora.multiply(BigDecimal.valueOf(horasEsperadas - horasTrabalhadas));
        } else if (horasTrabalhadas > horasEsperadas) {
            adicional = valorHora.multiply(BigDecimal.valueOf(1.5))
                                  .multiply(BigDecimal.valueOf(horasTrabalhadas - horasEsperadas));
        }

        BigDecimal beneficios = getTotalBeneficiosAtivos(funcionarioId);
        BigDecimal vencimentos = salarioBase.add(adicional).add(beneficios);
        BigDecimal valorLiquido = vencimentos.subtract(desconto);

        ContraCheque c = new ContraCheque();
        c.setFuncionarioId(funcionarioId);
        c.setValorBruto(salarioBase);
        c.setDescontos(desconto);
        c.setValorLiquido(valorLiquido);
        c.setMes(mes);
        c.setAno(ano);

        boolean ok = this.gravar(c);
        if (ok) {
            registrarEvento(c.getIdContraCheque(), "Salário base", salarioBase, false);
            if (adicional.compareTo(BigDecimal.ZERO) > 0) {
                registrarEvento(c.getIdContraCheque(), "Hora extra (50%)", adicional, false);
            }
            if (beneficios.compareTo(BigDecimal.ZERO) > 0) {
                registrarEvento(c.getIdContraCheque(), "Benefícios", beneficios, false);
            }
            if (desconto.compareTo(BigDecimal.ZERO) > 0) {
                registrarEvento(c.getIdContraCheque(), "Desconto por faltas", desconto, true);
            }

            // Carrega impostos com alias camelCase
            this.conectar();
            String impSQL = 
                "SELECT idImposto, descricao, tipo, " +
                "faixa_inicio AS faixaInicio, faixa_fim AS faixaFim, " +
                "aliquota, parcela_deduzir AS parcelaDeduzir " +
                "FROM imposto WHERE tipo IN ('INSS','IRRF')";
            PreparedStatement impStmt = conn.prepareStatement(impSQL);
            ResultSet impRs = impStmt.executeQuery();

            List<Imposto> listaImpostos = new ArrayList<>();
            while (impRs.next()) {
                Imposto imp = new Imposto();
                imp.setIdImposto(impRs.getInt("idImposto"));
                imp.setDescricao(impRs.getString("descricao"));
                imp.setTipo(impRs.getString("tipo"));
                imp.setFaixaInicio(impRs.getBigDecimal("faixaInicio"));
                imp.setFaixaFim(impRs.getBigDecimal("faixaFim"));
                imp.setAliquota(impRs.getBigDecimal("aliquota"));
                imp.setParcelaDeduzir(impRs.getBigDecimal("parcelaDeduzir"));
                listaImpostos.add(imp);
            }
            this.desconectar();

            BigDecimal totalImpostos = BigDecimal.ZERO;
            for (Imposto i : listaImpostos) {
                BigDecimal valorImp = calcularValorImposto(i, salarioBase);
                if (valorImp.compareTo(BigDecimal.ZERO) > 0) {
                    registrarImposto(c.getIdContraCheque(), i.getIdImposto(), valorImp);
                    registrarEvento(c.getIdContraCheque(), i.getDescricao(), valorImp, true);
                    totalImpostos = totalImpostos.add(valorImp);
                }
            }

            c.setDescontos(c.getDescontos().add(totalImpostos));
            c.setValorLiquido(vencimentos.subtract(c.getDescontos()));
            this.gravar(c);
        }

        return ok;
    }

    public BigDecimal calcularValorImposto(Imposto imposto, BigDecimal base) {
        if (base.compareTo(imposto.getFaixaInicio()) >= 0 &&
            (imposto.getFaixaFim() == null || base.compareTo(imposto.getFaixaFim()) <= 0)) {
            BigDecimal aliquotaFrac = imposto.getAliquota()
                                             .divide(BigDecimal.valueOf(100), 10, BigDecimal.ROUND_HALF_UP);
            return base.multiply(aliquotaFrac).subtract(imposto.getParcelaDeduzir());
        }
        return BigDecimal.ZERO;
    }
    
    
    
    //Barra de busca
//barra de busca para o funcionario
public List<ContraCheque> buscarPorTermo(String termo) throws Exception {
    List<ContraCheque> lista = new ArrayList<>();

    String[] palavras = termo.trim().split("\\s+"); // Divide o termo por espaços se tiver mais de um termo

    StringBuilder sql = new StringBuilder();
    sql.append("SELECT c.*, f.nome AS nomeFuncionario FROM contra_cheque c ");
    sql.append("INNER JOIN funcionario f ON f.idFfuncionario = c.funcionario_idFfuncionario ");
    sql.append("WHERE 1=1 ");

    for (String palavra : palavras) {
        sql.append("AND (");
        sql.append("CAST(c.idContra_cheque AS CHAR) LIKE ? OR ");
        sql.append("CAST(c.valorBruto AS CHAR) LIKE ? OR ");
        sql.append("CAST(c.descontos AS CHAR) LIKE ? OR ");
        sql.append("CAST(c.valorLiquido AS CHAR) LIKE ? OR ");
        sql.append("CAST(c.funcionario_idFfuncionario AS CHAR) LIKE ? OR ");
        sql.append("CAST(c.mes AS CHAR) LIKE ? OR ");
        sql.append("CAST(c.ano AS CHAR) LIKE ? OR ");
        sql.append("f.nome LIKE ? OR ");
        sql.append("CONCAT(LPAD(c.mes, 2, '0'), '/', c.ano) LIKE ? ");  // <- Aqui a mágica pra "02/2024"
        sql.append(") ");
    }

    this.conectar();
    try (PreparedStatement pstm = conn.prepareStatement(sql.toString())) {
        int paramIndex = 1;
        for (String palavra : palavras) {
            String filtro = "%" + palavra + "%";
            for (int j = 0; j < 9; j++) {  // Agora são 9 campos por palavra (8 antigos + 1 novo do CONCAT)
                pstm.setString(paramIndex++, filtro);
            }
        }

        ResultSet rs = pstm.executeQuery();
        while (rs.next()) {
            ContraCheque c = new ContraCheque();
            c.setIdContraCheque(rs.getInt("idContra_cheque"));
            c.setValorBruto(rs.getBigDecimal("valorBruto"));
            c.setDescontos(rs.getBigDecimal("descontos"));
            c.setValorLiquido(rs.getBigDecimal("valorLiquido"));
            c.setFuncionarioId(rs.getInt("funcionario_idFfuncionario"));
            c.setMes(rs.getInt("mes"));
            c.setAno(rs.getInt("ano"));
            c.setNomeFuncionario(rs.getString("nomeFuncionario"));
            lista.add(c);
        }
    } finally {
        this.desconectar();
    }

    return lista;
}

}
