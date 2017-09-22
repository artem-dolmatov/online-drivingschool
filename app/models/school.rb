class School < ActiveRecord::Base
  belongs_to :city
  has_many :users

  include AdminBase

  # signatures
  self.signatures = {
          create_element: 'Создание школы',
          edit_element: 'Редактирование школы',
          add_element: 'Добавить школу',
          elements: 'Школы',
          list_elements: 'Список школ'
  }

  # properties of table
  self.table_props = [{
                              name: '#',
                              machine: 'id',
                              type: 'text',
                              template: 'default',
                              options: {
                                      icon: '',
                                      show_in_modal: true
                              },
                              roles: []
                      }, {
                              name: 'Название',
                              machine: 'name',
                              type: 'text',
                              template: 'default',
                              options: {
                                      icon: ''
                              },
                              roles: []
                      }, {
                              name: 'Город',
                              machine: 'city.try(:name)',
                              type: 'text',
                              template: 'default',
                              options: {
                                      icon: ''
                              },
                              roles: []
                      }]

  # field of form
  self.form_fields = [{
                              name: 'Название',
                              machine: 'name',
                              type: 'text',
                              template: 'default',
                              options: {
                                      actions: []
                              },
                              validates: {
                                      rules: {required: true},
                                      messages: {
                                              required: 'Поле Название обязательно для заполнения'
                                      },
                                      actions: []
                              },
                              roles: []
                      }, {
                              name: 'Город',
                              machine: 'city_id',
                              type: 'select',
                              template: 'default',
                              items: 'City.all.map{ |city| [city.name, city.id] }',
                              options: {
                                      prompt: 'Выберите',
                                      actions: []
                              },
                              validates: {
                                      rules: {required: true},
                                      messages: {
                                              required: 'Поле Город обязательно для заполнения'
                                      },
                                      actions: []
                              },
                              roles: []
                      }]

  def school_city
      name = "#{self.name} #{self.city.name}"
      name
  end

  def table_row_color
  end
end
