# Generated by Django 3.0.3 on 2020-07-30 15:13

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('home', '0008_auto_20200730_1454'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='game',
            options={'ordering': ['-date_edited']},
        ),
    ]
