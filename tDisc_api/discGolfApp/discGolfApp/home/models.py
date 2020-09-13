from django.db import models
from localflavor.us.models import USStateField
from django.core.validators import validate_comma_separated_integer_list
from django.contrib.auth import get_user_model
from datetime import date
from django.utils import timezone
import datetime

User = get_user_model()

class Course(models.Model):
    name = models.CharField(max_length=100, default="NA")
    state = USStateField(("state"), default= 'NA')
    city = models.CharField(("city"), max_length=64, default="NA")
    address = models.CharField(("address"), max_length=128, default="NA")
    zip_code =  models.CharField(("zip code"), max_length=5, default="00000")
    rating = models.DecimalField(max_digits=2, decimal_places=1, default=0)
    latitude = models.FloatField(default = 0.0000)
    longitude = models.FloatField(default= 0.0000)
    def __str__(self):
        return self.name

    def get_par_total(self):
        ch = CourseHoles.objects.filter(course=self)
        if ch.exists():
            course_holes = ch.first()
            return course_holes.get_par_total()
        return 0

class CourseHoles(models.Model):
    numberOfHoles = models.IntegerField(default=0)
    parList = models.CharField(validators=[validate_comma_separated_integer_list], max_length=27, default = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0])
    distList = models.CharField(validators=[validate_comma_separated_integer_list], max_length=27, default = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0])
    course = models.ForeignKey(Course, on_delete=models.CASCADE)
    

    def __str__(self):
        return 'course holes for ' + str(self.course)

    def get_par(self, holeNum):
        par_array = self.convert_to_array(self.parList)
        if holeNum > self.numberOfHoles:
            return 0
        else:
            return par_array[holeNum-1]

    def get_par_total(self):
        total = 0
        par_array = self.convert_to_array(self.parList)
        for x in par_array:
            total+=int(x)
        print("par total "+str(total))
        return total

    def convert_to_array(self, csil):
        csil = csil.replace('[','')
        csil = csil.replace(']','')
        array = csil.split(',')
        return array

class Game(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    course = models.ForeignKey(Course, on_delete = models.CASCADE)
    scoreList = models.CharField(validators=[validate_comma_separated_integer_list], max_length=27, default = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0])
    date_created = models.DateField(default = datetime.date.today, null=True, blank=True)
    date_edited = models.DateField(default = datetime.date.today, null=True, blank=True)
    score = models.IntegerField(default=0)
    class Meta:
        ordering =["-date_edited"]
    def save(self, *args, **kwargs):
        self.date_edited = datetime.date.today()
        super(Game, self).save()

    def update_game(self, holeNum, numOfThrows):
        score_array = self.convert_to_array(self.scoreList)
        holeNum = int(holeNum)
        numOfThrows = int(numOfThrows)
        if holeNum > len(score_array) or holeNum <= 0:
            return False
        score_array[holeNum-1] = numOfThrows
        self.scoreList = str(score_array)
        course_total = self.course.get_par_total()
        game_total = self.get_total_pts()
        parList  = CourseHoles.objects.get(course=self.course).parList
        print(parList)
        self.score = self.calc_score(self.scoreList, parList)
        print(self.score)
        return True
    def calc_score(self, scoreList, parList) :
        score_array = self.convert_to_array(scoreList)
        par_array = self.convert_to_array(parList)
        index = 0
        x = score_array[index]
        score = 0
        while x != 0 :
            score += (x - par_array[index])
            index+=1
            x = score_array[index]
        return score

    def get_numOfThrows(self, holeNum):
        score_array =  self.convert_to_array(self.scoreList)
        if holeNum > len(score_array) or holeNum <= 0:
            return 0
        return int(score_array[holeNum-1])

    def get_total_pts(self):
        total = 0
        score_array = self.convert_to_array(self.scoreList)
        for x in score_array:
            total+=int(x)
        return total

    def get_score(self):
        return self.score
    
    def convert_to_array(self, csil):
        csil = csil.replace('[','')
        csil = csil.replace(']','')
        array_str = csil.split(',')
        array_int = []
        for x in array_str:
            array_int.append(int(x))
        return array_int