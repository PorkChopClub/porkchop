class RenameSchemaMigrationsTable < ActiveRecord::Migration
  def up
    #                              _____
    #                         ,---';;;;;`--.
    #                       ,';;;;;; '''''''`-,
    #                      ; ;;;;,,;;;;;;;;;;;`;
    #                     ` ;;; ; ;;;;;;;;,-'`-;
    #                     ` ;;;;' ;;; ;;;; ,-'~
    #    SHIP IT       /\  /\ ;'  ;;;;;;; ,-'
    #          \     ,--`/ ^;    ;:;;;;  ;
    #           \  .'        `.   ;;;;;  `.
    #             ,' (O)       ;  ;; ;;;; `.
    #            (v}'         ,' ; ;; ;;;; `.
    #             `-.--'   _,'`.  :;;;  ;;; :
    #            _._ ~`---' ,-  `.`.;;;;;; ;`.
    #           /___\ ;   ,'     :  . ;; ;; ;;
    #          c|##c==-.__;      `-. ; ;;;;; ;
    #          c:##c==,_  `    ,'  `-.;;;;;;;;
    #           `----'  `------',    `.; ;;;;;
    #                :     __,----. , `.;;;;;
    #              ,'`.  ,' ,     ' `  ;;;;;
    #              :  `.,' ,`       , ,';;
    #              `._  : ,`       ,_,,'
    #           __,-' `-`_`   ____,-'
    #          Ccc_,----'_`--'   _)
    #                 CCcc_,----'

    drop_table 'rails_schema_migrations' if table_exists?('rails_schema_migrations')
    rename_table 'schema_migrations', 'rails_schema_migrations' if table_exists?('schema_migrations')
    ActiveRecord::SchemaMigration.reset_column_information
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
