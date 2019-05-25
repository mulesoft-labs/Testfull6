public interface IMsTriggerHandler {

    void beforeInsert();

    void afterInsert();

    void beforeUpdate();

    void afterUpdate();

    void beforeDelete();

    void afterDelete();

    void afterUndelete();

    void handle();

}