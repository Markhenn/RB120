class Student
  attr_reader :name
  def initialize(n, g)
    @name = n
    @grade = g
  end

  def better_grade_than?(student)
    grade > student.grade
  end
    
  protected

  def grade
    @grade
  end

end

bob = Student.new('Bob', 60)
joe = Student.new('Joe', 75)
tim = Student.new('Tim', 90)

puts joe.better_grade_than?(bob) == true
puts joe.better_grade_than?(tim) == false

puts "Well done!" if joe.better_grade_than?(bob)
puts "Well done!" if joe.better_grade_than?(tim)
