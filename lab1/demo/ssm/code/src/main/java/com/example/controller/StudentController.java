package com.example.controller;

import com.example.pojo.Student;
import com.example.service.StudentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping(value = "/student")
public class StudentController {
    /**
     * 注入service层
     * 使用@Resource和@Autowired都可以实现Bean的自动注入
     */
    @Autowired
    private StudentService studentService;

    /**
     * 跳转到添加学生信息功能页面
     */
    @RequestMapping("/toSavePage")
    public String toSavePage() {
        return "page/save";
    }

    /**
     * 跳转到学生信息展示界面
     *
     * @return
     */
    @RequestMapping(value = "/toListPage")
    public String toListPage(Model model) {
        return "redirect:findByPage.do";
    }

    /**
     * 保存学生信息
     *
     * @param student
     * @param model
     * @return
     */
    @RequestMapping(value = "/save")
    public String create(Student student, Model model) {
        try {
            studentService.create(student);
            model.addAttribute("message", "保存学生信息成功");
        } catch (Exception e) {
            e.printStackTrace();
        }

        return "page/info";
    }

    /**
     * 删除学生信息
     *
     * @param id
     * @param model
     * @return
     */
    @RequestMapping("/delete")
    public String delete(@RequestParam Long id, Model model) {
        try {
            studentService.delete(id);
            model.addAttribute("message", "删除客户信息成功");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "page/info";

    }

    @ResponseBody
    @RequestMapping(value = "/findById")
    public Student findById(@RequestBody Student student) {
        Student student_info = studentService.findById(student.getId());
        if (student_info != null) {
            return student_info;
        } else {
            return null;
        }
    }

    @RequestMapping(value = "/update")
    public String update(Student student, Model model) {
        try {
            studentService.update(student);
            model.addAttribute("message", "更新学生信息成功");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "page/info";
    }


    @RequestMapping("/findByPage")
    public String findByPage(Student student,
                             @RequestParam(value = "pageCode", required = false, defaultValue = "1") int pageCode,
                             @RequestParam(value = "pageSize", required = false, defaultValue = "5") int pageSize,
                             Model model) {
        model.addAttribute("page", studentService.findByPage(student, pageCode, pageSize));
        return "page/list";
    }

}
