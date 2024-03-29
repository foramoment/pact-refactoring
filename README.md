# README

1. Связь между моделями поменял на `has_and_belongs_to_many`, добавил соответствующие миграции.
2. Исправлена опечатка в модели `Skill` и при обращении к `Interest`. Обращения к хешу по строкам заменил на символы.
3. С `ActiveInteraction` прежде не работал, почитал доку, понял что не нужно проверять наличие параметров в хеше в методе `run`, это умеет делать `ActiveInteraction`, ещё и типы можно указать. Поправил.
4. Проверка на существование пользователя `User.where(email: params['email'])` всегда будет возвращать `ActiveRecord::Relation` и никогда не будет `nil`. Поменял на `User.where('LOWER(email) = LOWER(?)', params[:email]).exists?`, на всякий случай использовал приведение к нижнему регистру средствами DB.
5. Проверку возраста переписал через использование диапазона `(1..90).include?(params[:age])`. В оригинальной строчке использовался оператор `or`, имеющий другой приоритет, чем `||`.
6. Проверка вхождения пола в 2 значения реализовал проверкой включения в массив: `%w[male female].include?(params[:gender])`
7. Формирование `full_name` из ФИО переписал более коротко и учитывая кейс, что отчества может и не быть: `params.values_at(:surname, :name, :patronymic).join(" ").strip`
8. Поиск и добавление `Skills` и `Interests` сделал через `find_each` и используя оператор `<<`
9. Создание пользователя и добавление к нему Skills и Interests завернул в транзакцию, чтобы либо всё завершалось корректно, либо откатывалось.
9. `User.create` заменил на `User.new`, всё равно он сохраняется в конце транзакции с методом `save!`
10. Методы проверки существования пользователя в бд, проверки возраста и пола вынесены в отдельные методы для большей читаемости и упрощения восприятия

Ссылка на оригинальный файл для рефакторинга: https://github.com/foramoment/pact-refactoring/blob/main/refactor_me.rb
Ссылка на итоговый: https://github.com/foramoment/pact-refactoring/blob/main/app/interactions/users/create.rb
