class Tasks {
  static _client;
  static _tableName = 'tasks';

  static async bulkCreate(values) {
    const valuesString = values
      .map(
        ({ attr, domain, constraints, associations }) =>
          `('${attr}','${domain}', ${constraints}, ${associations})`
      )
      .join(',');

    const { rows } = await this._client.query(`
    INSERT INTO "${this._tableName}" (
      "attr",
      "domain", 
      "constraints",
      "associations"
    ) VALUES ${valuesString}
    RETURNING *;`);
    return rows;
  }
}

module.exports = Tasks;
