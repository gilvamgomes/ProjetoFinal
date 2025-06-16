package utils;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.YearMonth;
import java.util.List;

public class HorasUtils {

    /**
     * Calcula quantas horas um funcionário deveria trabalhar no mês,
     * considerando feriados, fins de semana e carga horária padrão.
     *
     * @param ano            Ano desejado
     * @param mes            Mês desejado (1 a 12)
     * @param feriados       Lista de datas que são feriados
     * @param trabalhaSabado true se a pessoa trabalha aos sábados, false se não
     * @return Total de horas esperadas no mês
     */
    public static double calcularHorasEsperadasMes(int ano, int mes, List<LocalDate> feriados, boolean trabalhaSabado) {
        double totalHoras = 0.0;

        YearMonth ym = YearMonth.of(ano, mes);

        for (int dia = 1; dia <= ym.lengthOfMonth(); dia++) {
            LocalDate data = LocalDate.of(ano, mes, dia);
            DayOfWeek diaSemana = data.getDayOfWeek();

            if (feriados.contains(data)) {
                continue; // pula feriado
            }

            if (diaSemana == DayOfWeek.SUNDAY) {
                continue; // pula domingo
            }

            if (diaSemana == DayOfWeek.SATURDAY) {
                if (trabalhaSabado) {
                    totalHoras += 4.0;
                }
            } else {
                totalHoras += 8.0; // segunda a sexta
            }
        }

        return totalHoras;
    }
}
