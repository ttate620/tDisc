# Generated by Django 3.0.3 on 2020-07-30 15:33

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('home', '0009_auto_20200730_1513'),
    ]

    operations = [
        migrations.AlterField(
            model_name='game',
            name='date_created',
            field=models.DateField(blank=True, null=True),
        ),
        migrations.AlterField(
            model_name='game',
            name='date_edited',
            field=models.DateField(blank=True, null=True),
        ),
    ]
