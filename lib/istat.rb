# Istat

require 'csv'
require 'open-uri'
require 'zip/zip'

class Istat
  def self.seed_as_province(url = 'http://www.istat.it/strumenti/definizioni/comuni/ripartizioni_regioni_province.csv')
    cols = %w(
    codice_ripartizione
    codice_nuts1
    ripartizione_geografica_maiuscolo
    ripartizione_geografica
    codice_regione
    codice_nuts2
    denominazione_regione_maiuscolo
    denominazione_regione
    codice_provincia
    codice_nuts3
    denominazione_provincia
    sigla_automobilistica
    )
    open(url) do |f|
      f.each_line do |line|
        CSV.parse(line, :col_sep => ';') do |row|
          if row.size == cols.size
            data = Hash.new
            cols.each_with_index do |item, index|
              data[item.to_sym] = row[index]
            end
            yield data
          end
        end rescue nil
      end
    end if block_given?
  end

  def self.seed_as_municipality(url = 'http://www.istat.it/strumenti/definizioni/comuni/elenco_comuni_italiani_30_giugno_2010.csv')
    cols = %w(
    codice_regione
    codice_provincia
    codice_comune
    codice_istat_comune_alfanumerico
    codice_istat_comune_numerico
    codice_istat_comune_103_province_numerico
    codice_istat_comune_107_province_numerico
    denominazione_italiano_tedesco
    denominazione_italiano
    denominazione_tedesco
    comune_capoluogo_provincia
    zona_altimetrica
    altitudine_centro
    comune_litoraneo
    comune_montano
    codice_sistema_locale_lavoro_2001
    denominazione_sistema_locale_lavoro_2001
    superficie_territoriale_totale
    popolazione_legale_2001
    popolazione_residente_2008
    popolazione_residente_2009
    )
    open(url) do |f|
      f.each_line do |line|
        CSV.parse(line, :col_sep => ';') do |row|
          if row.size == cols.size
            data = Hash.new
            cols.each_with_index do |item, index|
              data[item.to_sym] = row[index]
            end
            yield data
          end
        end rescue nil
      end
    end if block_given?
  end

  def self.seed_as_zip(url = 'http://lab.comuni-italiani.it/files/listacomuni.zip')
    cols = %w(
    codice_istat_comune_alfanumerico
    denominazione_italiano
    sigla_automobilistica
    sigla_regione
    prefisso_telefonico
    cap
    codice_catastale
    link        
    )
    open(url) do |f|
      Zip::ZipFile.open(f.path) do |zip|
        zip.get_input_stream('listacomuni.txt').each_line do |line|
          CSV.parse(line, :col_sep => ';') do |row|
            if row.size == cols.size
              data = Hash.new
              cols.each_with_index do |item, index|
                data[item.to_sym] = row[index]
              end
              p data
              # yield data
            end
          end rescue nil
        end
      end
    end
  end
end