<workspace-zen-table class="containerV" style="flex-grow:1">
  <div class="containerH" style="height:80px;justify-content: center; align-items: center;flex-shrink:0;">
    <input 
      class="searchbox inputStandard"
      type="text"
      name="inputSearch"
      ref="inputSearch"
      placeholder="Rechercher vos workspaces..."
      oninput={updateSearch}
    />
  </div>

  <zenTable show={filteredData.length > 0} drag={false} disallowselect={true} ref="zentable" disallowdelete={opts.disallowdelete}>
    <yield to="header">
      <div class="containerTitle">
        <div class="tableTitleName">NOM</div>
        <div class="tableTitleDescription">DESCRITPION</div>
        <div class="tableTitleDate">DATE DE MODIFICATION</div>
        <div class="tableEmpty"/>
      </div>
    </yield>
    <yield to="row">
      <div class="tableRowName">{name}</div>
      <div class="tableRowDescription">{description.slice(0,20)}</div>
      <div class="tableRowDate">{renderDate(updatedAt)}</div>
    </yield>
  </zenTable>

  <div if={filteredData.length === 0} class="containerH" style="flex-grow:1;justify-content:center;">
    <div class="containerV" style="flex-basis:1;justify-content:center;margin:50px">
      <h1 style="text-align: center;color: rgb(119,119,119);">
        { opts.emptyText }
      </h1>
    </div>
  </div>

  <script>
    renderDate = (date) => (
      `${new Date(date).getDate()} ${['janv.',
        'févr.',
        'mars',
        'avr.',
        'mai',
        'juin',
        'juil.',
        'août',
        'sept.',
        'oct.',
        'nov.',
        'dec.'][new Date(date).getMonth()]} ${new Date(date).getFullYear()}`
    ) 
    this.filter = ''
    this.filteredData = []

    this.reload = () => {
      this.filteredData = this.filterData(this.opts.data)
      this.refs.zentable.data = this.filteredData
    }

    this.filterData = (data) => {
      if (this.filter === undefined || this.filter === null || this.filter === '') {
        return data
      } else {
        return sift(
          { name: { $regex: new RegExp(this.filter, 'i') } },
          data
        )
      }
    }

    this.updateSearch = (event) => {
      this.filter = event.target.value
      this.reload()
    }

    this.on('mount', () => {
      this.reload()
      this.tags.zentable.on('rowNavigation', (data) => route('workspace/' + data._id + '/component'))
      this.tags.zentable.on('delRow', (data) => this.trigger('deleteRow', data))

      this.update()
    })

    this.on('update', () => {
      this.reload()
    })
  </script>

  <style>
    ::placeholder{
      color: rgb(200,200,200);
      font-style: italic;
      opacity: 1; /* Firefox */
    }
    .tableRowName {
      font-size: 0.85em;
      flex:0.3;
      padding: 10px;
    }
    .tableRowDescription {
      font-size: 0.85em;
      flex:0.4;
      padding: 10px;
    }
    .tableRowDate {
      font-size: 0.85em;
      flex:0.3;
      padding: 10px;
    }
    .containerTitle {
      border-radius: 2px;
      width: 90%;
      flex-direction: row;
      display: flex;
      justify-content: center;
      align-items: center;
      background-color: rgb(26, 145, 194);
    }
    .tableTitleName {
      font-size: 0.85em;
      flex:0.255;
      color: white;
      flex-shrink: 0;
      padding-left:10px;
    }
    .tableTitleDescription {
      font-size: 0.85em;
      flex:0.340;
      color: white;
      flex-shrink: 0;
      padding-left:10px;
    }
    .tableTitleDate {
      font-size: 0.85em;
      flex:0.255;
      color: white;
      flex-shrink: 0;
    }
    .tableEmpty {
      flex:0.15;
    }
  </style>
</workspace-zen-table>
